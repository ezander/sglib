% identification
model=mfilename;

% geometry
geom='lshape';
num_refine=0;

% right hand side
dist_f={'uniform', {-1,1}, 0.0, 1 };
m_f=5;
p_f=3;
l_f=40;
cov_f_func=@gaussian_covariance;
lc_f=0.2;

% coefficient field
dist_k={'beta', {4,2}, 0.1, 1.0 };
[a,b]=beta_find_ratio( 0.2 );
a=1; b=1;

dist_k={'beta', {a,b}, 0.001, 1.0 };

m_k=5;
m_k=20;
p_k=3;
l_k=40;
cov_k_func=@exponential_covariance;
cov_k_func=@gaussian_covariance;
lc_k=[0.01 0.2];
lc_k=[0.4];

% dirichlet boundary field
mean_g_func=make_spatial_func('sin(pi*y/2)*cos(pi*x/3)');
mean_g_func=make_spatial_func('x*(1-y^2)');
is_neumann=make_spatial_func('x<0');


% solution
p_u=3;
