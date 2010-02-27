function demo_animation
% DEMO_ANIMATION Shows a smoothly varying random field.

clf;
animation_control( 'start', gcf );
view_mode=2;
set( gcf, 'Renderer', 'painters' );

kl_model_version=[];
[m_f, pos,els, f_i_k, f_i_alpha, I_f]=...
    load_kl_model( 'rf_kl_2d-1', kl_model_version, [], {'m_r', 'pos', 'els', 'r_i_k', 'r_k_alpha', 'I_r'} );

N=200;
xi_N=randn(m_f,N);
pp = interp1(linspace(1,1000,N),xi_N','spline','pp');

for i=1:1000
    xi=ppval(pp,i);
    xi=(xi-mean(xi))/sqrt(var(xi))+mean(xi);
    f_ex=kl_pce_field_realization( f_i_k, f_i_alpha, I_f, xi );
    plot_field( pos, els, f_ex, 'lighting', 'gouraud', 'view', view_mode );
    zlim([-4,4]);
    drawnow;

    if ~animation_control( 'check' )
        disp('quitting...');
        return
    end
end


function ret=animation_control( cmd, varargin )
if isoctave
    error( 'animation_control:no_octave_yet', 'This does not work with Octave yet.' );
end
switch cmd
    case 'start'
        set( gcf, 'WindowButtonUpFcn', @stop_animation );
        set( gcf, 'UserData', 1 );
        disp('Click into the graphics window to stop the demo...' );
    case 'check'
        h=get(0,'CurrentFigure');
        if h
            ret=~isempty( get( h, 'UserData' ) );
        else
            ret=false;
        end
    case 'stop'
        h=get(0,'CurrentFigure');
        if h
            set( h, 'UserData', [] );
        end
end


function stop_animation(src,evt) %#ok
set( gcf, 'UserData', [] );
