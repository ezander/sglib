cov_f={@gaussian_covariance,{lc_f,1}};
% create field
[f_i_alpha, I_f]=expand_field_pce_sg( stdnor_f, cov_f, [], pos, G_N, p_f, m_f );
[mu_f_i,f_i_k,phi_k_alpha]=pce_to_kl( f_i_alpha, I_f, l_f, G_N );
%'done'
%% define (deterministic) boundary conditions g
% this defines the function g(x)=x_1
select=@(x,n)(x(:,n));
g_func={ select, {1}, {2} };
% dummy pce (just the mean)
g_i_alpha=funcall( g_func, pos);
I_g=multiindex(0,0);
% "null" kl expansion of g
[mu_g_i,g_i_k,gamma_k_alpha]=pce_to_kl( g_i_alpha, I_g, 0 );


%% combine the multiindices
% (i.e. build the product sample space $Omega_u=Omega_k \times Omega_f \times
% Omega_g$ in which the solution lives)
[I_k,I_f,I_g,I_u]=multiindex_combine( {I_k, I_f, I_g}, -1 );
M=size(I_u,1); %#ok, full stochastic dimension


%% create the right hand side
% i.e. scale the pce coefficients with the norm of the stochastic ansatz
% functions and create tensor, matrix and vector versions out of it
phi_k_beta=compute_pce_rhs( phi_k_alpha, I_f, I_u );
F=kl_to_tensor( mu_f_i, f_i_k, phi_k_beta );
f_mat=F{1}*F{2}';
f_vec=f_mat(:);

gamma_k_beta=compute_pce_rhs( gamma_k_alpha, I_g, I_u );
G=kl_to_tensor( mu_g_i, g_i_k, gamma_k_beta );
g_mat=G{1}*G{2}';
g_vec=g_mat(:);


%% load and create the operators 
% since this takes a while we cache the function call
kl_operator_version=1;
stiffness_func={@stiffness_matrix, {els, pos}, {1,2}};
opt.silent=false;
opt.show_timings=true;
op_filename=sprintf('kl_operator_1d_%d_%d.mat', N, M );

% create tensor operators
K=compute_kl_pce_operator(mu_k_i, k_i_k, kappa_k_alpha, I_k, I_u, stiffness_func, 'mu_delta');

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

u_i_alpha=apply_boundary_conditions_solution( ui_mat, g_mat, P_I, P_B );
l_u=min(size(u_i_alpha));
[mu_u_i,u_i_k,u_k_alpha]=pce_to_kl( u_i_alpha, I_u, l_u, G_N );

%%
% the preconditioner
Mi=Ki(1,:);
Mi_mat=revkron( Mi );
