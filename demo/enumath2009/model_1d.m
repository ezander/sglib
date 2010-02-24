latex_opts={'Interpreter', 'latex', 'FontSize', 16, };
tex_opts={'Interpreter', 'tex' };
noint_opts={'Interpreter', 'none' };
text_opts=tex_opts;


%% load the geomatry
% 1D currently, so nothing to plot here
N=51;
d=1;
[pos,els,bnd]=create_mesh_1d( N, 0, 1 );
G_N=mass_matrix( pos, els );


%% load the kl variables of the conductivity k
% define stochastic parameters
p_k=4;
m_k=4;
l_k=4;
lc_k=0.3;
stdnor_k={@beta_stdnor,{4,2}};
cov_k={@gaussian_covariance,{lc_k,1}};
% create field
[k_i_alpha, I_k]=expand_field_pce_sg( stdnor_k, cov_k, [], pos, G_N, p_k, m_k );
[mu_k_i,k_i_k,kappa_k_alpha]=pce_to_kl( k_i_alpha, I_k, l_k, G_N );
% plot field
clf;
plot(pos,k_i_k); 
title('KL eigenfunctions of $\kappa$', text_opts{:});
print( 'rf_k_kl_eig.eps', '-depsc' );
plot_kl_pce_realizations_1d( pos, mu_k_i, k_i_k, kappa_k_alpha, I_k, 'realizations', 50 ); 
title('mean/var/samples of $\kappa$', text_opts{:} );
print( 'rf_k_kl_real.eps', '-depsc' );
userwait;

%% load the kl variables of the right hand side f 
% define stochastic parameters
p_f=3;
m_f=2;
l_f=4;
lc_f=2*0.3;
stdnor_f={@beta_stdnor,{4,2}};
cov_f={@gaussian_covariance,{lc_f,1}};
% create field
[f_i_alpha, I_f]=expand_field_pce_sg( stdnor_f, cov_f, [], pos, G_N, p_f, m_f );
[mu_f_i,f_i_k,phi_k_alpha]=pce_to_kl( f_i_alpha, I_f, l_f, G_N );
% plot field
clf;
plot(pos,f_i_k); 
title('KL eigenfunctions of $f$', text_opts{:});
print( 'rf_f_kl_eig.eps', '-depsc' );
plot_kl_pce_realizations_1d( pos, mu_f_i, f_i_k, phi_k_alpha, I_f, 'realizations', 50 ); 
title('mean/var/samples of $f$', text_opts{:});
print( 'rf_f_kl_real.eps', '-depsc' );
userwait;

%% define (deterministic) boundary conditions g
% this defines the function g(x)=x_1
select=@(x,n)(x(n,:)');
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
stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};
opt.silent=false;
opt.show_timings=true;
op_filename=sprintf('kl_operator_1d_%d_%d.mat', N, M );

% create tensor operators
K=cached_funcall(...
    @compute_kl_pce_operator,...
    { mu_k_i, k_i_k, kappa_k_alpha, I_k, I_u, stiffness_func, 'mu_delta' }, ...
    1,... % just one output argument
    op_filename, ...
    kl_operator_version, ...
    'message', 'recomputing kl-operator', ...
    'show_timings', opt.show_timings, 'silent', opt.silent, ...
    'extra_params', {'show_timings', opt.show_timings, 'silent', opt.silent}...
);

% create matrix and tensor operators
K_mat=revkron(K);


%% apply boundary conditions
[P_I,P_B]=boundary_projectors( bnd, N );

Ki=apply_boundary_conditions_operator( K, P_I );
Ki_mat=apply_boundary_conditions_operator( K_mat, P_I );

Fi=apply_boundary_conditions_rhs( K, F, G, P_I, P_B );
fi_vec=apply_boundary_conditions_rhs( K_mat, f_vec, g_vec, P_I, P_B );
fi_vec2=apply_boundary_conditions_rhs( K, f_vec, g_vec, P_I, P_B );
fi_mat=apply_boundary_conditions_rhs( K, f_mat, g_mat, P_I, P_B );
%
if false
    all_same=(norm(fi_vec-fi_vec2)+norm(fi_vec-fi_mat(:))+norm(Fi{1}*Fi{2}'-fi_mat)==0);
    underline('apply_boundary_conditions');
    fprintf( 'all_same: %g\n', all_same );
end

%% solve the system via direct solver for comparison
ui_vec=Ki_mat\fi_vec;
ui_mat=reshape( ui_vec, [], M );
[U_,S_,V_]=svd(ui_mat);
Ui={U_*S_,V_};

%%
% the preconditioner
Mi=Ki(1,:);
Mi_mat=revkron( Mi );
