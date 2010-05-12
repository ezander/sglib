% geometry
geom='';
N=1000;

% right hand side
dist_f={'uniform', {-1,1}, 0.0, 1 };
m_f=20;
p_f=2;
l_f=40;
cov_f_func=@gaussian_covariance;
lc_f=0.05;

% coefficient field
ratio=0.2;
[a,b]=beta_find_ratio(ratio);
dist_k={'beta', {a,b}, 0.0001, 1.0 };
m_k=20;
p_k=2;
l_k=40;
cov_k_func=@exponential_covariance;
lc_k=0.03;

% dirichlet boundary field
mean_g_func=make_spatial_func('sin(pi*y/2)*cos(pi*x/3)');

% solution
p_u=2;
