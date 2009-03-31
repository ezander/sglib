function show_covariances( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, cov_k, cov_f )
[X,Y]=meshgrid(x,x);
C_k=pce_covariance( k_alpha, I_k );
C_f=pce_covariance( f_alpha, I_f );
C_u=pce_covariance( u_alpha, I_u );
clf;
[mu_k,var_k]=pce_moments(k_alpha(2,:),I_k); %#ok
[mu_f,var_f]=pce_moments(f_alpha(2,:),I_f); %#ok
subplot(3,3,1); surf( X, Y, normalize_cov(C_k) )
subplot(3,3,4); surf( X, Y, var_k*covariance_matrix( x, cov_k ) )
subplot(3,3,7); surf( X, Y, C_k-var_k*covariance_matrix( x, cov_k ) )
subplot(3,3,2); surf( X, Y, normalize_cov(C_f) )
subplot(3,3,5); surf( X, Y, var_f*covariance_matrix( x, cov_f ) )
subplot(3,3,8); surf( X, Y, C_f-var_f*covariance_matrix( x, cov_f ) )
subplot(3,3,3); surf( X, Y, normalize_cov(C_u) )

%%
