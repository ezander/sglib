geom='lshape';
num_refine=1;

m_f=5;
p_f=3;
l_f=40;
lc_f=0.2;
cov_f_func=@gaussian_covariance;
dist_f={'uniform', {-1,1}, 0.0, 1 };

m_k=5;
p_k=4;
l_k=40;
lc_k=[0.01 0.2];
cov_k_func=@exponential_covariance;
dist_k={'beta', {4,2}, 0.1, 1.0 };

p_u=3;
