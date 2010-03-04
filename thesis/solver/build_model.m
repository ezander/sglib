%% load or create the geomatry
geom=get_param( 'geom', '' );
if isempty(geom)
    N=get_param( 'N', 50 );
    [pos,els,bnd_nodes]=create_mesh_1d( 0, 1, N );
    G_N=mass_matrix( pos, els );
    stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};
    d=1;
else
    num_refine=get_param( 'num_refine', 1 );
    show_mesh=get_param( 'show_mesh', false );
    [pos,els,G_N]=load_pdetool_geom( geom, num_refine, show_mesh );
    N=size(pos,2);
    bnd_nodes=find_boundary( els, true );
    stiffness_func={@stiffness_matrix, {pos, els}, {1,2}}; % could be changed to a pdetool function
    d=2;
end

%% construct the conductivity random field k
% define stochastic expansion parameters
p_k=get_param( 'p_k', 4 );
m_k=get_param( 'm_k', 4 );
l_k=get_param( 'l_k', 4 );

% define the distribution (name, parameters, shift, scale)
dist_k=get_param( 'dist_k', {'beta', {4,2}, 0.1, 1.0 } );
stdnor_k=@(x)(gendist_stdnor(x,dist_k{:}));

% define the covariance of the field
lc_k=get_param( 'lc_k', 0.3 );
cov_k_func=get_param( 'cov_k_func', @gaussian_covariance );
cov_k=get_param( 'cov_k', {cov_k_func,{lc_k,1}} );

% expand the field
[k_i_k,k_k_alpha,I_k]=expand_field_kl_pce( stdnor_k, cov_k, pos, G_N, p_k, m_k, l_k );


%% construct the right hand side random field f 
% define stochastic expansion parameters
p_f=get_param( 'p_f', 3 );
m_f=get_param( 'm_f', 2 );
l_f=get_param( 'l_f', 4 );

% define the distribution
dist_f=get_param( 'dist_k', {'beta', {4,2}, 0, 1.0 } );
stdnor_f=@(x)(gendist_stdnor(x,dist_f{:}));

% define 
lc_f=get_param( 'lc_f', 0.6 );
cov_f_func=get_param( 'cov_f_func', @gaussian_covariance );
cov_f=get_param( 'cov_f', {cov_f_func,{lc_f,1}} );

[f_i_k,f_k_alpha,I_f]=expand_field_kl_pce( stdnor_f, cov_f, pos, G_N, p_f, m_f, l_f );


%% construct the (deterministic) boundary conditions g
% this defines the function g(x)=x_1
select=@(x,n)(x(n,:)');
g_func={ select, {1}, {2} };
% dummy pce (just the mean)
g_i_alpha=funcall( g_func, pos);
I_g=multiindex(0,0);
% "null" kl expansion of g
[g_i_k,g_k_alpha]=pce_to_kl( g_i_alpha, I_g, 0 );


return 
% the rest should go into "discretize_bla where bla is one full_pce, kl,
% third order...)


%% combine the multiindices
% (i.e. build the product sample space $Omega_u=Omega_k \times Omega_f \times
% Omega_g$ in which the solution lives)

%[I_k,I_f,I_g,I_u]=multiindex_combine( {I_k, I_f, I_g}, -1 );
[I_f,I_g,I_r]=multiindex_combine( {I_f, I_g}, -1 );
M_k=size(I_k,1);
M_r=size(I_r,1);
G_k=spdiags(multiindex_factorial(I_k),0,M_k,M_k);
G_r=spdiags(multiindex_factorial(I_r),0,M_r,M_r);
M=0;

%% create the right hand side
% i.e. scale the pce coefficients with the norm of the stochastic ansatz
% functions and create tensor, matrix and vector versions out of it
f_k_beta=compute_pce_rhs( f_k_alpha, I_f, I_r );
F=kl_to_tensor( f_i_k, f_k_beta );

g_k_beta=compute_pce_rhs( g_k_alpha, I_g, I_r );
G=kl_to_tensor( g_i_k, g_k_beta );


%% load and create the operators 

% create tensor operators
K=compute_kl_pce_operator(k_i_k, k_k_alpha, I_k, I_k, stiffness_func, 'mu_delta');

% extend stuff to third order
K=extend_kl_operator( K, I_r );
F=extend_rhs( F, I_k );
G=extend_rhs( G, I_k );



%% apply boundary conditions
[P_I,P_B]=boundary_projectors( bnd_nodes, size(pos,2) );

Ki=apply_boundary_conditions_operator( K, P_I );
Fi=apply_boundary_conditions_rhs( K, F, G, P_I, P_B );

%% the preconditioner
Mi=Ki(1,:);
Mi_mat=tensor_operator_to_matrix( Mi );

%% solve the system via direct solver for comparison
% create matrix and tensor operators
if false
    K_mat=tensor_operator_to_matrix(K);
    %Ki_mat=apply_boundary_conditions_operator( K_mat, P_I );
    %fi_vec=apply_boundary_conditions_rhs( K_mat, f_vec, g_vec, P_I, P_B );
    %fi_vec2=apply_boundary_conditions_rhs( K, f_vec, g_vec, P_I, P_B );
    f_vec=tensor_to_vector( F );
    g_vec=tensor_to_vector( G );
    
    %ui_vec=Ki_mat\fi_vec;
    %ui_mat=reshape( ui_vec, [], M );
    %[U_,S_,V_]=svd(ui_mat);
    %Ui={U_*S_,V_};
    
    U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
    u_i_alpha=apply_boundary_conditions_solution( ui_mat, g_mat, P_I, P_B );
    l_u=min(size(u_i_alpha));
    [u_i_k,u_k_alpha]=pce_to_kl( u_i_alpha, I_u, l_u, G_N );
    %[u_i_k,u_k_alpha]=tensor_to_kl( U );
end
    
