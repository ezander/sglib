clear

%% 1. Define the geometry
geom='lshape';
num_refine=1;
show_mesh=false;
[pos,els,G_N,ptdata]=load_pdetool_geom( geom, num_refine, show_mesh );
[d,N]=size(pos);
bnd_nodes=find_boundary( els, true );
stiffness_func={@pdetool_stiffness_matrix, {ptdata}, {1}};


show_mesh_with_points( pos, els, [] );
title( 'Step 1: Define the geometry' );
userwait;

%% 2. Construct the conductivity random field k

%% 2.1 Define the distribution
dist_k={'beta', {1.1,4}, 0.1, 1.0 };
mean_k_func=get_param( 'mean_k_func', [] );

x=point_range( [0,1]+0.1, 'N', 500, 'ext', 0.1 );
plot( x, gendist_pdf( x, dist_k{:} ) );
title( 'Step 2.1: Define the distribution of $\kappa$' );
userwait;

%% 2.2 Define the covariance
cov_k_handle=@exponential_covariance;
lc_k=[0.05 0.2];
cov_k_func={cov_k_handle, {lc_k,1}};

x=point_range( [-1,0,1], 'N', 200 );
plot( x, funcall( cov_k_func, [x;0*x], [] ) ); hold all;
plot( x, funcall( cov_k_func, [0*x;x], [] ) ); hold off;
legend( 'x-direction', 'y-direction' )
title( 'Step 2.2: Define the covariance of $\kappa$' );
userwait;

%% 2.3 Check the KL convergence
C_k=covariance_matrix( pos, cov_k_func );
[k_i_k,sigma_k_k]=kl_solve_evp( C_k, G_N, 40 );
[kl_rem,~,~,sigma_ex]=kl_estimate_eps( sigma_k_k );

plot( sigma_k_k/sigma_k_k(1), 'k*-' ); hold all;
plot( sigma_ex/sigma_ex(1), 'b-' ); hold off;

stdnor_k={@gendist_stdnor, dist_k};
m_k=5;
p_k=4;
l_k=40;
eps_k=get_param( 'eps_k', 0 );

% define stochastic expansion parameters

% define the distribution (name, parameters, shift, scale)
dist_k=get_param( 'dist_k', {'beta', {4,2}, 0.1, 1.0 } );

% define the covariance of the field
lc_k=get_param( 'lc_k', 0.3 );
cov_k_func=get_param( 'cov_k_func', @gaussian_covariance );
cov_k=get_param( 'cov_k', {cov_k_func,{lc_k,1}} );

% expand the field
[k_i_k,k_k_alpha,I_k,l_k]=expand_field_kl_pce( stdnor_k, cov_k, pos, G_N, p_k, m_k, l_k, 'eps', eps_k, 'mean_func', mean_k_func );
