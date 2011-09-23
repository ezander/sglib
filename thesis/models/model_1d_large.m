% identification
model=mfilename;

% geometry
geom='';
N=1000;

% right hand side
dist_f={'uniform', {-1,1}, 0.0, 1 };
m_f=35;
p_f=2;
l_f=35;
cov_f_func=@gaussian_covariance;
lc_f=0.02;

% coefficient field
[a,b]=beta_find_ratio( 0.2 );
dist_k={'beta', {a,b}, 0.001, 1.0 };
m_k=10;
p_k=4;
l_k=10;
cov_k_func=@exponential_covariance;
lc_k=0.05;

% dirichlet boundary field
mean_g_func=make_spatial_func('sin(pi*y/2)*cos(pi*x/3)');

m_g=0;
p_g=1;
l_g=0;

m_h=0;
p_h=1;
l_h=0;

% solution
p_u=2;


