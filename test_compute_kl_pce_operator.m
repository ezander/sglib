clear

N=get_param( 'N', 50 );
[pos,els,bnd_nodes]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );
stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};


[a,b]=beta_find_ratio( 0.2 );
dist_k={'beta', {a,b}, 0.001, 1.0 };
m_k=10;
p_k=3;
l_k=10;
cov_k_func=@exponential_covariance;
lc_k=0.05;

eps_k=0.01;

stdnor_k={@gendist_stdnor, dist_k};
cov_k={cov_k_func,{lc_k,1}};
mean_k_func=[];

% expand the field
[k_i_k,k_k_alpha,I_k,l_k]=expand_field_kl_pce( stdnor_k, cov_k, pos, G_N, p_k, m_k, l_k, 'eps', eps_k, 'mean_func', mean_k_func );

verbose=get_param( 'verbose', true );

tic
K=kl_pce_compute_operator(k_i_k, k_k_alpha, I_k, I_k, stiffness_func, 'tensor');
toc
