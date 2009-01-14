function demo_animation
% DEMO_ANIMATION Shows a smoothly varying random field.

init_demos( true );

clf; clear

if ismatlab
    set(gcf, 'WindowButtonUpFcn', @stop_demo );
else
    error( 'This demo does not work with Octave yet.' );
end

%[p_f, m_gam_f, m_f, lc_f, h_f, cov_f, cov_gam, els, pos, f_alpha, I_f, mu_f, f_i_alpha, v_f]=
kl_model_version=[];
[m_gam_f, els, pos, mu_f, v_f, f_i_alpha, I_f]=...
    load_kl_model( 'rf_kl_2d-1', kl_model_version, [], {'m_gam_r', 'els', 'pos', 'mu_r_j', 'r_i_j', 'rho_i_alpha', 'I_r'} );


xi1=randn(1,m_gam_f);
xi2=randn(1,m_gam_f);
set( gcf, 'UserData', [] ); % just in case
disp('Click into the graphics window to stop the demo...' );
for i=1:100
    for s=0:0.1:0.9
        sp=s^1.5;
        xi=(1-sp)*xi1+sp*xi2;
        f_ex=kl_pce_field_realization( pos, mu_f, v_f, f_i_alpha, I_f, xi );
        plot_field( els, pos, zinn_harvey_connected_stdnor( f_ex, 0.1, true ) );
        
        if ~isempty( get( gcf, 'UserData' ) ) 
            set( gcf, 'UserData', [] );
            disp('quitting...');
            return
        end
    end
    xi1=xi2;
    xi2=randn(1,m_gam_f);
end


function stop_demo(src,evt) %#ok
set( gcf, 'UserData', 1 );
