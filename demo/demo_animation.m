function demo_animation
% DEMO_ANIMATION Shows a smoothly varying random field.

clf;
if ismatlab
    set(gcf, 'WindowButtonUpFcn', @stop_demo );
else
    error( 'This demo does not work with Octave yet.' );
end


kl_model_version=[];
[m_gam_f, els, pos, mu_f, v_f, f_i_alpha, I_f]=...
    load_kl_model( 'rf_kl_2d-1', kl_model_version, [], {'m_gam_r', 'els', 'pos', 'mu_r_j', 'r_j_i', 'rho_i_alpha', 'I_r'} );

N=200;
xi_N=randn(N,m_gam_f);
pp = interp1(linspace(1,1000,N),xi_N,'spline','pp');

set( gcf, 'UserData', [] ); % just in case
disp('Click into the graphics window to stop the demo...' );
for i=1:1000
    xi=ppval(pp,i)';
    xi=(xi-mean(xi))/sqrt(var(xi))+mean(xi);
    f_ex=kl_pce_field_realization( pos, mu_f, v_f, f_i_alpha, I_f, xi );
    plot_field( els, pos, f_ex, 'lighting', 'gouraud' );

    if ~isempty( get( gcf, 'UserData' ) )
        set( gcf, 'UserData', [] );
        disp('quitting...');
        return
    end
end


function stop_demo(src,evt) %#ok
set( gcf, 'UserData', 1 );
