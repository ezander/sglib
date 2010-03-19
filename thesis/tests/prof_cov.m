profile on

n=8500;
sig=3; L=.02; K=4;
x=linspace(-1,2,n);
tic
C_u=covariance_matrix( x, {@gaussian_covariance, {L,sig}}, 'max_dist', K*L );
nnz(C_u)/numel(C_u)
toc
tic
C_u2=covariance_matrix( x, {@gaussian_covariance, {L,sig}} );
nnz(C_u2)/numel(C_u2)
toc
% C_u_ex=toeplitz(sig^2*exp(-(x+1).^2/L^2));
% assert_equals( C_u, C_u_ex, 'cov_matrix_4L', 'abstol', sig^2*exp(-K^2) );

profile off
profile viewer
        