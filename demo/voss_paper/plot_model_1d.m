%% check that all external parameters are set
if ~exist('model_base','var')
    error('parameter model_base not set')
end

% plot field f
clf;
plot(pos,f_i_k); 
title('KL eigenfunctions of $f$' );
save_figure( model_base, 'f-kl_eigfun' )

plot_kl_pce_realizations_1d( pos, mu_f_i, f_i_k, phi_k_alpha, I_f, 'realizations', 50 ); 
title('mean/var/samples of $f$');
save_figure( model_base, 'f-samples' )


% plot field f
clf;
plot(pos,u_i_k); 
title('KL eigenfunctions of $u$' );
save_figure( model_base, 'u-kl_eigfun' )

plot_kl_pce_realizations_1d( pos, mu_u_i, u_i_k, u_k_alpha, I_u, 'realizations', 50 ); 
title('mean/var/samples of $u$');
save_figure( model_base, 'u-samples' )

