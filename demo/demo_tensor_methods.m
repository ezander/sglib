%function demo_tensor_methods

init_demos

clf; clear
basename='rf_kl_1d_sfem21';
setuserwaitmode( 'continue' );

%% load the geomatry
kl_model_version=1;
[pos,els,bnd]=load_kl_model( [basename '_k'], kl_model_version, [], {'pos','els','bnd'} );
% 1D currently, so nothing to plot here

%% load the kl variables of the conductivity k
[mu_k_j,k_j_i,kappa_i_alpha,I_k]=load_kl_model( [basename '_k'], kl_model_version, [], {'mu_r_j', 'r_j_i', 'rho_i_alpha', 'I_r'} );
k_add_mu=0.1; mu_scale_sigma=1;
kappa_i_alpha(:,1)=k_add_mu+kappa_i_alpha(:,1); % shift mean
kappa_i_alpha(:,2:end)=mu_scale_sigma*kappa_i_alpha(:,2:end); % scale variance
subplot(1,2,1); plot(pos,k_j_i); title('KL eigenfunctions');
subplot(1,2,2); plot_kl_pce_realizations_1d( pos, mu_k_j, k_j_i, kappa_i_alpha, I_k ); title('mean/var/samples');
userwait;

%% load the kl variables of the right hand side f 
[mu_f_j,f_j_i,phi_i_alpha,I_f]=load_kl_model( [basename '_f'], kl_model_version, [], {'mu_r_j', 'r_j_i', 'rho_i_alpha', 'I_r'} );
subplot(1,2,1); plot(pos,f_j_i); title('KL eigenfunctions');
subplot(1,2,2); plot_kl_pce_realizations_1d( pos, mu_f_j, f_j_i, phi_i_alpha, I_f ); title('mean/var/samples');
userwait;

%%
[I_k,I_f,I_u]=multiindex_combine( {I_k, I_f}, -1 );
f_j_alpha=f_j_i*phi_i_alpha; % kl_pce to full pce
f_j_alpha(:,1)=mu_f_j;
f_j_beta=stochastic_pce_rhs( f_j_alpha, I_f, I_u );
xi=randn( 30, size(I_u,2) );
subplot(2,2,3); plot_kl_pce_realizations_1d( pos, mu_f_j, f_j_i, phi_i_alpha, I_f, 'xi', xi ); title('mean/var/samples');
subplot(2,2,1); plot_pce_realizations_1d( pos, f_j_alpha, I_f, 'xi', xi ); title('pce mean/var/samples');
subplot(2,2,2); plot_pce_realizations_1d( pos, f_j_beta, I_u, 'xi', xi ); title('pce*H^2 mean/var/samples');
userwait;


%% load and create the operators 
kl_operator_version=4;
stiffness_func={@stiffness_matrix, {els, pos}, {1,2}};
K_mu_delta=load_kl_operator( [basename '_op_mu_delta'], kl_operator_version, mu_k_j, k_j_i, kappa_i_alpha, I_k, I_u, stiffness_func, 'mu_delta' );
K_ab=load_kl_operator( [basename '_op_ab'], kl_operator_version, mu_k_j, k_j_i, kappa_i_alpha, I_k, I_u, stiffness_func, 'alpha_beta' );
% create matrix and tensor operators
K={ K_mu_delta{1}, K_mu_delta{3}{:}; K_mu_delta{2},K_mu_delta{4}{:} };
Kmat=cell2mat(K_ab);




trunc_k=20;
trunc_eps=1e-7;
M_N=[];
M_Phi=[];

%g_func=@(x)(x(:,1));
subsel.type='()';
subsel.subs={':',1};
g_func={ @subsref, {subsel}, {2} }

mu_g_j=zeros(size(mu_f_j,1),size( funcall( g_func, pos(1,:)),2));
mu_g_j(bnd,:)=funcall( g_func, pos(bnd,:));
G=kl_to_tensor( mu_g_j, zeros(size(mu_g_j,1),0), zeros(0,size(I_u,1)) );
[P_B,P_I]=boundary_projectors( bnd, size(mu_g_j,1) );



phi_i_beta=stochastic_pce_rhs( phi_i_alpha, I_f, I_u );
F=kl_to_tensor( mu_f_j, f_j_i, phi_i_beta );

[Ks,fs]=apply_boundary_conditions( K, f, g, P_B, P_I, m, varargin )


H=tensor_apply_kl_operator( K_mu_delta, G, trunc_k, trunc_eps, M_N, M_Phi, true );
F2=tensor_reduce( tensor_add( F, H ), trunc_k, trunc_eps );
F2



