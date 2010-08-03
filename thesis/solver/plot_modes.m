function show_modes( f_i_k,f_k_alpha, pos, cov_f, G_N, F )
if size(f_i_k,1)>3000; return; end

[mu_fs_i,fs_i_k,sigma_fs_k,fs_k_alpha]=kl_pce_to_standard_form(f_i_k,f_k_alpha); 
C_f=covariance_matrix( pos, cov_f );
[r_i_k,sigma_f]=kl_solve_evp( C_f, G_N, 30 );
sigma_F=tensor_modes(F);
close
hold all
plot( sigma_f/sigma_f(1) )
plot( sigma_fs_k/sigma_fs_k(1) )
plot( sigma_F/sigma_F(1) )
drawnow;

