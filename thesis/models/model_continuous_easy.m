% identification
model=mfilename;

% geometry
geom='lshape';

% right hand side
dist_f={'uniform', {-1,1}, 0.0, 1 };
cov_f_func=@gaussian_covariance;
lc_f=0.8;

cov_f_func=@exponential_covariance;
lc_f=1.8;

% coefficient field
[a,b]=beta_find_ratio( 0.15 );
dist_k={'beta', {a,b}, 0.001, 1.0 };
cov_k_func=@gaussian_covariance;
lc_k=1.3;
lc_k=0.8;

% dirichlet boundary field
mean_g_func=make_spatial_func('0');
%mean_g_func=make_spatial_func('sin(pi*y/2)*cos(pi*x/3)');

mean_g_func=make_spatial_func('x*(1-y^2)');
is_neumann=make_spatial_func('x<=-1');
m_g=0;
p_g=1;
l_g=0;

m_h=0;
p_h=1;
l_h=0;

% solution
p_u=3;
