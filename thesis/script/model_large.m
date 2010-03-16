% geometry
geom='lshape';
num_refine=1;

% right hand side
dist_f={'uniform', {-1,1}, 0.0, 1 };
m_f=5;
p_f=3;
l_f=40;
cov_f_func=@gaussian_covariance;
lc_f=0.2;

% coefficient field
dist_k={'beta', {4,2}, 0.1, 1.0 };
m_k=5;
p_k=4;
l_k=40;
cov_k_func=@exponential_covariance;
lc_k=[0.01 0.2];

% dirichlet boundary field
mean_g_func=make_spatial_func('sin(pi*y/2)*cos(pi*x/3)');

% solution
p_u=3;
