% identification
model=mfilename;

% geometry
geom='lshape';

% right hand side
dist_f={'uniform', {-1,1}, 0.0, 1 };
cov_f_func=@gaussian_covariance;
lc_f=0.9;

% coefficient field
[a,b]=beta_find_ratio( 0.2 );
dist_k={'beta', {a,b}, 0.001, 1.0 };
cov_k_func=@gaussian_covariance;
%cov_k_func=@exponential_covariance;
lc_k=1.3;

% dirichlet boundary field
mean_g_func=make_spatial_func('0');
%mean_g_func=make_spatial_func('sin(pi*y/2)*cos(pi*x/3)');

% solution
p_u=3;
