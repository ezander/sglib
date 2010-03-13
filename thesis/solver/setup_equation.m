%% combine the multiindices
% (i.e. build the product sample space $Omega_u=Omega_k \times Omega_f \times
% Omega_g$ in which the solution lives)
I_k=multiindex(m_k,p_k);
I_f=multiindex(m_f,p_f);
I_g=multiindex(m_g,p_g);

p_u=get_param('p_u', max([p_k,p_f,p_g]));

[I_k,I_f,I_g,I_u]=multiindex_combine( {I_k, I_f, I_g}, p_u );
M=size(I_u,1);
I_RHS=I_u; % for 3way this would be I_k
I_OP=I_u;  % for 3way this would be combine( I
G_X=spdiags(multiindex_factorial(I_u),0,M,M);


%% create the right hand side
% i.e. scale the pce coefficients with the norm of the stochastic ansatz
% functions and create tensor, matrix and vector versions out of it
f_k_beta=compute_pce_rhs( f_k_alpha, I_f, I_RHS );
F=kl_to_tensor( f_i_k, f_k_beta );

g_k_beta=compute_pce_rhs( g_k_alpha, I_g, I_RHS );
G=kl_to_tensor( g_i_k, g_k_beta );


%% load and create the operators 

% create tensor operators
tic
K=kl_pce_compute_operator(k_i_k, k_k_alpha, I_k, I_OP, stiffness_func, 'tensor');
toc

%% apply boundary conditions
[P_I,P_B]=boundary_projectors( bnd_nodes, size(pos,2) );

Ki=apply_boundary_conditions_operator( K, P_I );
Fi=apply_boundary_conditions_rhs( K, F, G, P_I, P_B );
Mi_inv=stochastic_preconditioner_deterministic( Ki );
