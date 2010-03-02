N=50;


%% load the geomatry
% 1D currently, so nothing to plot here

if exist('geom','var') && ~strcmp(geom,'1d')
    error( 'unknown geometry' ); %#ok<ERTAG>
end

[pos,els,bnd]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );
stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};

%% load the kl variables of the conductivity k
% define stochastic parameters
p_k=4;
m_k=4;
l_k=4;
dist='beta';
dist_params={4,2};
rng=[0,1.2];
dist_shift=0.1;
dist_scale=1;



stdnor_k=@(x)(gendist_stdnor(x,dist,dist_params,dist_shift,dist_scale));
pdf_k=@(x)(gendist_pdf(x,dist,dist_params,dist_shift,dist_scale));
[mu_k,var_k]=gendist_moments(dist,dist_params,dist_shift,dist_scale);

lc_k=0.3;
cov_k={@gaussian_covariance,{lc_k,1}};

[k_i_k,k_k_alpha,I_k]=expand_field_kl_pce( stdnor_k, cov_k, [], pos, G_N, p_k, m_k, l_k );

%% load the kl variables of the right hand side f 
% define stochastic parameters
p_f=3;
m_f=2;
l_f=4;
stdnor_f={@beta_stdnor,{4,2}};

lc_f=2*0.3;
cov_f={@gaussian_covariance,{lc_f,1}};

[f_i_k,f_k_alpha,I_f]=expand_field_kl_pce( stdnor_f, cov_f, [], pos, G_N, p_f, m_f, l_f );

%% define (deterministic) boundary conditions g
% this defines the function g(x)=x_1
select=@(x,n)(x(n,:)');
g_func={ select, {1}, {2} };
% dummy pce (just the mean)
g_i_alpha=funcall( g_func, pos);
I_g=multiindex(0,0);
% "null" kl expansion of g
[g_i_k,g_k_alpha]=pce_to_kl( g_i_alpha, I_g, 0 );


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
K=compute_kl_pce_operator(k_i_k, k_k_alpha, I_k, I_u, stiffness_func, 'mu_delta');

% extend stuff to third order
K=extend_kl_operator( K, I_r );
F=extend_rhs( F, I_k );
G=extend_rhs( G, I_k );


%% apply boundary conditions
[P_I,P_B]=boundary_projectors( bnd, size(pos,1) );

Ki=apply_boundary_conditions_operator( K, P_I );
Fi=apply_boundary_conditions_rhs( K, F, G, P_I, P_B );

U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
u_i_alpha=apply_boundary_conditions_solution( ui_mat, g_mat, P_I, P_B );
l_u=min(size(u_i_alpha));
[u_i_k,u_k_alpha]=pce_to_kl( u_i_alpha, I_u, l_u, G_N );
%[u_i_k,u_k_alpha]=tensor_to_kl( U );


%%
% the preconditioner
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
    
    ui_vec=Ki_mat\fi_vec;
    ui_mat=reshape( ui_vec, [], M );
    [U_,S_,V_]=svd(ui_mat);
    Ui={U_*S_,V_};
    
    U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
    u_i_alpha=apply_boundary_conditions_solution( ui_mat, g_mat, P_I, P_B );
    l_u=min(size(u_i_alpha));
    [mu_u_i,u_i_k,u_k_alpha]=pce_to_kl( u_i_alpha, I_u, l_u, G_N );
    %[mu_u_i,u_i_k,u_k_alpha]=tensor_to_kl( U );
end
    
