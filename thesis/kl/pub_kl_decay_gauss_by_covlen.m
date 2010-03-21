%% Decay of KL eigenfunctions
% Elmar Zander, March 2010


%% Preliminary: Load geometry and model data
clear; clf;
geom='scatter';
num_refine=1;
l=30; L=sqrt(2);
define_geometry
x=linspace(0,L);

%gaussian_decay=@(lc,L,d,k)sqrt( (L/lc).^(k.^(1/d)+2)./gamma(0.5*k.^(1/d)) );
gaussian_decay=@(lc,L,d,k)sqrt( 1./gamma(1+0.5*(k.^(1/d))) );

plot_mesh( pos, els, 'color', 'b' );
plot_boundary( pos, els, 'color', 'r' );
axis equal
axis tight

%% 1.1  Gaussian covariance

%% Covariance length 0.3
lc=0.3;
cov_func={@gaussian_covariance, {lc, 1} };
[v,sigma]=kl_solve_evp( covariance_matrix( pos, cov_func ), G_N, l );

subplot(1, 3, 1); plot( x, funcall( cov_func, x, [] ) );
subplot(1, 3, 2); plot( sigma );
subplot(1, 3, 3); semilogy( 1:30, sigma, 1:30, gaussian_decay(lc,L,1,1:30) );
k=1:l;
sqrt( 1./gamma(0.5*(k.^(1/d))) );
u=0.5*(k.^(1/d));
sqrt( 1./gamma(1+u) );

%% Covariance length 1
lc=1;
cov_func={@gaussian_covariance, {lc, 1} };
[v,sigma]=kl_solve_evp( covariance_matrix( pos, cov_func ), G_N, l );

subplot(1, 3, 1); plot( x, funcall( cov_func, x, [] ) );
subplot(1, 3, 2); plot( sigma );
subplot(1, 3, 3); semilogy( 1:30, sigma, 1:30, gaussian_decay(lc,L,2,1:30) );

%% Covariance length 3
lc=3;
cov_func={@gaussian_covariance, {lc, 1} };
[v,sigma]=kl_solve_evp( covariance_matrix( pos, cov_func ), G_N, l );
sigma=abs(sigma);

subplot(1, 3, 1); plot( x, funcall( cov_func, x, [] ) );
subplot(1, 3, 2); plot( sigma );
gaussian_decay=@(lc,L,d,k)sqrt( (L/lc).^(k.^(1/d)+2)./gamma(0.5*k.^(1/d)) );
subplot(1, 3, 3); semilogy( 1:30, sigma, 1:30, gaussian_decay(lc,L,1,1:30) );

