function demo_tensor_methods

init_demos

clf; clear
basename='rf_kl_1d_sfem21';
setuserwaitmode( 'continue' );

%% load the geomatry
% 1D currently, so nothing to plot here
kl_model_version=1;
[pos,els,bnd]=load_kl_model( [basename '_k'], kl_model_version, [], {'pos','els','bnd'} );
N=size(pos,1);

%% load the kl variables of the conductivity k
[mu_k_j,k_j_i,kappa_i_alpha,I_k]=load_kl_model( [basename '_k'], kl_model_version, [], {'mu_r_j', 'r_j_i', 'rho_i_alpha', 'I_r'} );
subplot(1,2,1); plot(pos,k_j_i); title('KL eigenfunctions');
subplot(1,2,2); plot_kl_pce_realizations_1d( pos, mu_k_j, k_j_i, kappa_i_alpha, I_k ); title('mean/var/samples');
userwait;

%% load the kl variables of the right hand side f 
[mu_f_j,f_j_i,phi_i_alpha,I_f]=load_kl_model( [basename '_f'], kl_model_version, [], {'mu_r_j', 'r_j_i', 'rho_i_alpha', 'I_r'} );
subplot(1,2,1); plot(pos,f_j_i); title('KL eigenfunctions');
subplot(1,2,2); plot_kl_pce_realizations_1d( pos, mu_f_j, f_j_i, phi_i_alpha, I_f ); title('mean/var/samples');
userwait;

%% define (deterministic) boundary conditions g
% this defines the function g(x)=x_1
select=@(x,n)(x(:,n));
g_func={ select, {1}, {2} };
mu_g_j=funcall( g_func, pos);
% "null" kl expansion of g
I_g=multiindex(0,0);
g_j_i=zeros(N,0);
gamma_i_alpha=zeros(0,size(I_g,1));


%% combine the multiindices
[I_k,I_f,I_g,I_u]=multiindex_combine( {I_k, I_f, I_g}, -1 );
M=size(I_u,1);


%% create the right hand side
phi_i_beta=stochastic_pce_rhs( phi_i_alpha, I_f, I_u );
F=kl_to_tensor( mu_f_j, f_j_i, phi_i_beta );
f_mat=F{1}*F{2}';
f_vec=f_mat(:);

gamma_i_beta=stochastic_pce_rhs( gamma_i_alpha, I_g, I_u );
G=kl_to_tensor( mu_g_j, g_j_i, gamma_i_beta );
g_mat=G{1}*G{2}';
g_vec=g_mat(:);


%% load and create the operators 
kl_operator_version=9;
stiffness_func={@stiffness_matrix, {els, pos}, {1,2}};
opt.silent=false;
opt.show_timings=true;
K=load_kl_operator( [basename '_op_mu_delta'], kl_operator_version, mu_k_j, k_j_i, kappa_i_alpha, I_k, I_u, stiffness_func, 'mu_delta', opt );
K_ab=load_kl_operator( [basename '_op_ab'], kl_operator_version, mu_k_j, k_j_i, kappa_i_alpha, I_k, I_u, stiffness_func, 'alpha_beta', opt );
% create matrix and tensor operators
K_mat=cell2mat(K_ab);


%% apply boundary conditions
[P_B,P_I]=boundary_projectors( bnd, size(pos,1) );

[Ki,Fi]=apply_boundary_conditions( K, F, G, P_B, P_I );
[K_mat_i,f_vec_i]=apply_boundary_conditions( K_mat, f_vec, g_vec, P_B, P_I );
[Ki,f_vec_i2]=apply_boundary_conditions( K, f_vec, g_vec, P_B, P_I );
[Ki,f_mat]=apply_boundary_conditions( K, f_mat, g_mat, P_B, P_I );

% 
norm(f_vec_i-f_vec_i2)
norm(f_vec_i-f_mat(:))
norm(Fi{1}*Fi{2}'-f_mat)


%% solve the system 
u_vec_i=K_mat_i\f_vec_i;
norm( f_vec_i-tensor_operator_apply( Ki, u_vec_i ) );
norm( f_vec_i-tensor_operator_apply( K_mat_i, u_vec_i ) );

%Ui=tensor_operator_solve_jacobi( Ki, Fi, 'M', Ki(1,:) );



Mi=tkron( Ki{1,:} );
tic; u_vec_i3=pcg(K_mat_i,f_vec_i,[],[],Mi,[],[]); toc;
tic; u_vec_i2=pcg(@funcall_funfun,f_vec_i,[],[],Mi,[],[],{@tensor_operator_apply,{K_mat_i},{1}}); toc;







%trunc_k=20;
%trunc_eps=1e-7;
%G_N=[];
%G_Phi=[];
