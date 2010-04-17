clear

%% 1. Define the geometry
geom='lshape';
num_refine=2;
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
[kl_rem,params,sigma_ex]=kl_estimate_eps( sigma_k_k, 'Nout', 100, 'full', true );

plot( sigma_k_k/sigma_k_k(1), 'k*-' ); hold all;
plot( sigma_ex/sigma_k_k(1), 'b-' ); hold off;
legend( 'KL singular values', 'KL estimated' )
title( 'Step 2.3a: Check KL convergence of $\kappa$' );

%% 
eps_k=0.05;
l_k=find(kl_rem<=eps_k,1,'first');
rem_N=150;
plot( kl_rem(1:rem_N), '*-' ); hold all;
plot( 1:rem_N, repmat(eps_k,1,rem_N), '-' ); hold all;
plot( l_k,kl_rem(l_k), 'r*' ); hold off;
legend( 'KL remainder', 'threshold', sprintf('l_k=%d',l_k) )
title( 'Step 2.3b: KL remainder$\kappa$' );

%% look at gaussian random field
m_k=l_k;
[u_i_alpha, I_u]=expand_gaussian_field_pce( cov_k_func, pos, G_N, m_k );
%% show some realizations
mh=multiplot_init(2,3);
for i=1:numel(mh)
    u=pce_field_realization( u_i_alpha, I_u )
    multiplot;
    plot_field( pos, els, u, 'view', 3 );
    view( [135+90 70] )
    save_talk_figure_raster( mh(i), {'randfield_real_%d', i } );
end

%% show different approximation quality for mean+var depending on number of
%% Gaussians
mh=multiplot_init(2,4);

for m2=[10,30,60,114]
    u_i_alpha2=u_i_alpha(:,1:m2);
    I_u2=I_u(1:m2,:);
    multiplot; 
    plot_kl_pce_mean_var( pos, els, [], u_i_alpha2, I_u2 );
    multiplot; 
    plot_kl_pce_mean_var( pos, els, [], u_i_alpha2, I_u2 );
    view(45,0);
end
same_scaling(mh,'z');
same_scaling(mh,'c');


%%
[u_mean, u_var]=pce_moments( u_i_alpha, I_u );
subplot(2,1,1)
plot_field( pos, els, u_mean, 'view', 3 );
subplot(2,1,2)
plot_field( pos, els, u_var, 'view', 3 ); 
zlim( [0,2] )
set( gca, 'clim', [0,2] )
view(2)
rand



%%
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
