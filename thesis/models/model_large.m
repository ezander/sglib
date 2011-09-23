% identification
model=mfilename;

% geometry
geom='lshape';
num_refine=2;
num_refine_after=0;

% right hand side
dist_f={'uniform', {-1,1}, 0.0, 1 };
m_f=20;
p_f=3;
l_f=25;
cov_f_func=@gaussian_covariance;
lc_f=0.04;

% coefficient field
[a,b]=beta_find_ratio( 0.2 );
dist_k={'beta', {a,b}, 0.001, 1.0 };
m_k=10;
p_k=3;
l_k=20;
cov_k_func=@exponential_covariance;
lc_k=[0.05 0.2];

% dirichlet boundary field
mean_g_func=make_spatial_func('0');

% dirirchlet boundary conditions
m_g=0;
p_g=1;
l_g=0;

% neumann boundary conditions
m_h=0;
p_h=1;
l_h=0;


% solution
p_u=3;
