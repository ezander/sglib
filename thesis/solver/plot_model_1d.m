% plot field f
clf;
plot(pos,f_i_k); 
title('KL eigenfunctions of $f$' );
save_figure( model_base, 'f-kl_eigfun' )

plot_kl_pce_realizations_1d( pos, mu_f_i, f_i_k, phi_k_alpha, I_f, 'realizations', 50 ); 
title('mean/var/samples of $f$');
save_figure( model_base, 'f-samples' )

% plot field kappa
clf;
plot(pos,k_i_k); 
title('KL eigenfunctions of $kappa$' );
save_figure( model_base, 'k-kl_eigfun' )

plot_kl_pce_realizations_1d( pos, mu_k_i, k_i_k, kappa_k_alpha, I_k, 'realizations', 50 ); 
title('mean/var/samples of $\kappa$');
save_figure( model_base, 'k-samples' )

x=linspace(0,1.2);
y=pdf_k(x);
plot(x,y)
xlabel('x')
title('marginal density (local pdf) of $\kappa$');
save_figure( model_base, 'k-pdf' )

% plot field u
clf;
plot(pos,u_i_k); 
title('KL eigenfunctions of $u$' );
save_figure( model_base, 'u-kl_eigfun' )

plot_kl_pce_realizations_1d( pos, mu_u_i, u_i_k, u_k_alpha, I_u, 'realizations', 50 ); 
title('mean/var/samples of $u$');
save_figure( model_base, 'u-samples' )

