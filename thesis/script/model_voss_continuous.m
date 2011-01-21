% geometry
geom='lshape';

% right hand side
dist_f={'uniform', {-1,1}, 0.0, 1 };
cov_f_func=@gaussian_covariance;
lc_f=0.5;

% coefficient field
[a,b]=beta_find_ratio( 0.4 );
dist_k={'beta', {a,b}, 0.001, 1.0 };
cov_k_func=@exponential_covariance;
lc_k=0.7;

% dirichlet boundary field
mean_g_func=make_spatial_func('0');
