function show_goodness_of_approximations( K_ab, u_alpha0, f_beta, tsvd_options )
% How does the residual decrease with better approximation to the
% solution
m=min(size(u_alpha0))-1;
dk=m-1;
s=svd(u_alpha0);

fprintf('2-norm\n'); n=2;
norm_f_beta=norm(f_beta, n);
norm_u_alpha0=norm(u_alpha0, n);
for i=m:-1:m-dk
    u_alpha=truncated_svd( u_alpha0, i, tsvd_options );

    a(i,1)=norm(apply_stochastic_operator( K_ab, u_alpha)-f_beta, n)/norm_f_beta;
    a(i,2)=norm(u_alpha-u_alpha0, n)/norm_u_alpha0;
    a(i,3)=s(i+1)/max(s);

    fprintf( 'residual: %2d %10.7e   %10.7e  %10.7e\n', i, a(i,1), a(i,2), a(i,3) );
end
a(a(:,3)==0,3)=min(a(a(:,3)>0,3));
clf;
semilogy(1./a); legend('res','err','err-sing',   'Location','NorthWest' );
fprintf('frobenius\n'); n='fro';


%%
