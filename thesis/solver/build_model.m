%% load the geomatry
% 1D currently, so nothing to plot here

if exist('geom','var') && ~strcmp(geom,'1d')
    error( 'unknown geometry' );
end

[pos,els,bnd]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );

%% load the kl variables of the conductivity k
% define stochastic parameters
p_k=4;
m_k=4;
l_k=4;
lc_k=0.3;

stdnor_k=@(x)(gendist_stdnor(x,dist,dist_params,dist_shift,dist_scale));
pdf_k=@(x)(gendist_pdf(x,dist,dist_params,dist_shift,dist_scale));
[mu_k,var_k]=gendist_moments(dist,dist_params,dist_shift,dist_scale);

cov_k={@gaussian_covariance,{lc_k,1}};
% create field
[k_i_alpha, I_k]=expand_field_pce_sg( stdnor_k, cov_k, [], pos, G_N, p_k, m_k );
[k_i_k,k_k_alpha]=pce_to_kl( k_i_alpha, I_k, l_k, G_N );

%% load the kl variables of the right hand side f 
% define stochastic parameters
p_f=3;
m_f=2;
l_f=4;
lc_f=2*0.3;
%stdnor_f={@lognormal_stdnor,{0,2}};
stdnor_f={@beta_stdnor,{4,2}};

cov_f={@gaussian_covariance,{lc_f,1}};
% create field
[f_i_alpha, I_f]=expand_field_pce_sg( stdnor_f, cov_f, [], pos, G_N, p_f, m_f );
[f_i_k,f_k_alpha]=pce_to_kl( f_i_alpha, I_f, l_f, G_N );
%'done'
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
[I_k,I_f,I_g,I_u]=multiindex_combine( {I_k, I_f, I_g}, -1 );
M=size(I_u,1); %#ok, full stochastic dimension
G_X=spdiags(multiindex_factorial(I_u),0,M,M);


%% create the right hand side
% i.e. scale the pce coefficients with the norm of the stochastic ansatz
% functions and create tensor, matrix and vector versions out of it
f_k_beta=compute_pce_rhs( f_k_alpha, I_f, I_u );
F=kl_to_tensor( f_i_k, f_k_beta );
f_mat=F{1}*F{2}';
f_vec=f_mat(:);

g_k_beta=compute_pce_rhs( g_k_alpha, I_g, I_u );
G=kl_to_tensor( g_i_k, g_k_beta );
g_mat=G{1}*G{2}';
g_vec=g_mat(:);


%% load and create the operators 
% since this takes a while we cache the function call
kl_operator_version=1;
stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};
opt.silent=false;
opt.show_timings=true;
op_filename=sprintf('kl_operator_1d_%d_%d.mat', N, M );

% create tensor operators
K=compute_kl_pce_operator(k_i_k, k_k_alpha, I_k, I_u, stiffness_func, 'mu_delta');


% create matrix and tensor operators
K_mat=revkron(K);


%% apply boundary conditions
[P_I,P_B]=boundary_projectors( bnd, size(pos,1) );

Ki=apply_boundary_conditions_operator( K, P_I );
Ki_mat=apply_boundary_conditions_operator( K_mat, P_I );

Fi=apply_boundary_conditions_rhs( K, F, G, P_I, P_B );
fi_vec=apply_boundary_conditions_rhs( K_mat, f_vec, g_vec, P_I, P_B );
fi_vec2=apply_boundary_conditions_rhs( K, f_vec, g_vec, P_I, P_B );
fi_mat=apply_boundary_conditions_rhs( K, f_mat, g_mat, P_I, P_B );

%% solve the system via direct solver for comparison
ui_vec=Ki_mat\fi_vec;
ui_mat=reshape( ui_vec, [], M );
[U_,S_,V_]=svd(ui_mat);
Ui={U_*S_,V_};

U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
u_i_alpha=apply_boundary_conditions_solution( ui_mat, g_mat, P_I, P_B );
l_u=min(size(u_i_alpha));
[u_i_k,u_k_alpha]=pce_to_kl( u_i_alpha, I_u, l_u, G_N );
%[u_i_k,u_k_alpha]=tensor_to_kl( U );


%%
% the preconditioner
Mi=Ki(1,:);
Mi_mat=revkron( Mi );
