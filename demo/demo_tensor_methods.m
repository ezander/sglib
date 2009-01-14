function demo_tensor_methods

init_demos

clf; clear

basename='rf_kl_1d_sfem21';
kl_model_version=1;
[pos,els,bnd]=load_kl_model( [basename '_f'], kl_model_version, [], {'pos','els','bnd'} );
[mu_f_j,f_j_i,phi_i_alpha,I_f]=load_kl_model( [basename '_f'], kl_model_version, [], {'mu_r_j', 'r_j_i', 'rho_i_alpha', 'I_r'} );
[mu_k_j,k_j_i,kappa_i_alpha,I_k]=load_kl_model( [basename '_k'], kl_model_version, [], {'mu_r_j', 'r_j_i', 'rho_i_alpha', 'I_r'} );
%   k_alpha(:,1)=1+k_alpha(:,1); % shift mean
%   k_alpha(:,2:end)=0.5*k_alpha(:,2:end); % scale variance
[I_k,I_f,I_u]=multiindex_combine( {I_k, I_f}, -1 );


%types={'alpha_beta', 'mu_delta', 'mu_iota' };
stiffness_func={@stiffness_matrix, {els, pos}, {1,2}};
kl_operator_version=2;
K_ab=load_kl_operator( [basename '_op_ab'], kl_operator_version, [], mu_k_j, k_j_i, kappa_i_alpha, I_k, I_u, stiffness_func, 'alpha_beta' );
K_mu_delta=load_kl_operator( [basename '_op_mu_delta'], kl_operator_version, [], mu_k_j, k_j_i, kappa_i_alpha, I_k, I_u, stiffness_func, 'mu_delta' );
K_mu_iota=load_kl_operator( [basename '_op_iota'], 2, kl_operator_version, mu_k_j, k_j_i, kappa_i_alpha, I_k, I_u, stiffness_func, 'mu_iota' );
K_ab_mat=cell2mat(K_ab);

% f_beta=stochastic_pce_rhs( f_alpha, I_f, I_u, bnd );
f_j_alpha=f_j_i*phi_i_alpha;
f_j_beta=stochastic_pce_rhs( f_j_alpha, I_f, I_u );



trunc_k=20;
trunc_eps=1e-7;
M_N=[];
M_Phi=[];

g_func=@(x)(x(:,1));
mu_g_j=zeros(size(mu_f_j,1),size(g_func(pos(1,:)),2));
mu_g_j(bnd,:)=g_func(pos(bnd,:));
G=kl_to_tensor( mu_g_j, zeros(size(mu_g_j,1),0), zeros(0,size(I_u,1)) );
[P_B,P_I]=boundary_projectors( bnd, size(mu_g_1,1) );

phi_i_beta=stochastic_pce_rhs( phi_i_alpha, I_f, I_u );
F=kl_to_tensor( mu_f_j, f_j_i, phi_i_beta );

H=tensor_apply_kl_operator( K_mu_delta, G, trunc_k, trunc_eps, M_N, M_Phi, true );
F2=tensor_reduce( tensor_add( F, H ), trunc_k, trunc_eps );




