function show_corr_coeffs( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, cov_k, cov_f )
[X,Y]=meshgrid(x,x);
C_k=pce_covariance( k_alpha, I_k );
C_f=pce_covariance( f_alpha, I_f );
C_u=pce_covariance( u_alpha, I_u );
clf;
subplot(2,2,1); surf( X, Y, to_corr_coeff(C_k) )
subplot(2,2,2); surf( X, Y, to_corr_coeff(C_f) )
subplot(2,2,3); surf( X, Y, to_corr_coeff(C_u) )

%%
