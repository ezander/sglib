clear

%% load or create the geomatry
% !!! pos, els, G_N (kann auch stattdessen I sein) und stiffness_func
% werden von dem FEM code benoetigt, stiffness_func muss so sein, dass
% funcall(stiffness_func, k) die Steifigkeitsmatrix zurueckliefert, wobei k
% die Werte des Koeffizientenfeldes an den Knoten enthaelt (Faelle mit
% mehreren oder anisotropen Koeffizientenfeldern sind noch nicht moeglich)
[pos,els,G_N,ptdata]=load_pdetool_geom( 'lshape', 1, false );
bnd_nodes=find_boundary( els, true );
stiffness_func={@pdetool_stiffness_matrix, {ptdata}, {1}};
[d,N]=size(pos);


%% construct the conductivity random field k
% define stochastic expansion parameters

p_k=get_base_param( 'p_k', 2 );
m_k=get_base_param( 'm_k', 10 );
l_k=get_base_param( 'l_k', 10 );


% define the distribution (name, parameters, shift, scale)
dist_k=get_base_param( 'dist_k', {'beta', {4,2}, 0.1, 1.0 } );
mean_k_func=get_base_param( 'mean_k_func', [] );
stdnor_k={@gendist_stdnor, dist_k};

% define the covariance of the field
lc_k=get_base_param( 'lc_k', 0.3 );
cov_k_func=get_base_param( 'cov_k_func', @gaussian_covariance );
cov_k=get_base_param( 'cov_k', {cov_k_func,{lc_k,1}} );

% expand the field
[k_i_k,k_k_alpha,I_k,l_k]=expand_field_kl_pce( stdnor_k, cov_k, pos, G_N, p_k, m_k, l_k, 'mean_func', mean_k_func );

%% construct the right hand side random field f 
% define stochastic expansion parameters
p_f=get_base_param( 'p_f', 2 );
m_f=get_base_param( 'm_f', 10 );
l_f=get_base_param( 'l_f', 10 );

% define the distribution
dist_f=get_base_param( 'dist_f', {'beta', {4,2}, 0, 1.0 } );
mean_f_func=get_base_param( 'mean_f_func', [] );
stdnor_f={@gendist_stdnor, dist_f};

% define the covariance of the field
lc_f=get_base_param( 'lc_f', 0.6 );
cov_f_func=get_base_param( 'cov_f_func', @gaussian_covariance );
cov_f=get_base_param( 'cov_f', {cov_f_func,{lc_f,1}} );

[f_i_k,f_k_alpha,I_f,l_f]=expand_field_kl_pce( stdnor_f, cov_f, pos, G_N, p_f, m_f, l_f, 'mean_func', mean_f_func );


%% Construct the Dirichlet boundary conditions g 
% note that we construct g on the whole domain and later take only its
% values on the boundary)

p_g=get_base_param( 'p_g', 1 );
m_g=get_base_param( 'm_g', 0 );
l_g=get_base_param( 'l_g', 0 );
eps_g=get_base_param( 'eps_g', 0 );

% define the distribution
dist_g=get_base_param( 'dist_g', {'normal', {0,1}, 0, 1.0 } );
mean_g_func=get_base_param( 'mean_g_func', [] );
stdnor_g={@gendist_stdnor, dist_g};

% define the covariance of the field
lc_g=get_base_param( 'lc_g', 100 );
cov_g_func=get_base_param( 'cov_g_func', @gaussian_covariance );
cov_g=get_base_param( 'cov_g', {cov_f_func,{lc_g,1}} );

[g_i_k,g_k_alpha,I_g,l_g]=expand_field_kl_pce( stdnor_g, cov_g, pos, G_N, p_g, m_g, l_g, 'mean_func', mean_g_func );
g_i_k=clear_non_boundary_values( g_i_k, bnd_nodes );


%% combine the multiindices
% (i.e. build the product sample space $Omega_u=Omega_k \times Omega_f \times
% Omega_g$ in which the solution lives)
I_k=multiindex(m_k,p_k);
I_f=multiindex(m_f,p_f);
I_g=multiindex(m_g,p_g);

p_u=get_base_param('p_u', max([p_k,p_f,p_g]));

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


%% load and create the stochastic operator

% create tensor operators
verbose=get_base_param( 'verbose', true );
t_klop=tic;
K=kl_pce_compute_operator_fast(k_i_k, k_k_alpha, I_k, I_OP, stiffness_func, 'tensor');
if verbose; toc(t_klop); end

%% apply boundary conditions to operator and rhs
% !!! Die Randbedingungen sauber hereinzubekommen fand ich nicht ganz
% trivial. Hoffentlich klappt der Ansatz auch mit eurem Code und es ist
% hier keine Aenderung notwendig.

[P_I,P_B]=boundary_projectors( bnd_nodes, size(pos,2) );

Ki=apply_boundary_conditions_operator( K, P_I );
Fi=apply_boundary_conditions_rhs( K, F, G, P_I, P_B );

%% Solve the system 
% convert fields into matrix form
Fi_mat=tensor_to_array( Fi );
Mi_inv=stochastic_precond_mean_based( Ki );

maxiter=100;
reltol=1e-6;

tic; fprintf( 'Solving (gpcg): ' );
[Ui_mat,flag,info]=generalized_solve_pcg( Ki,Fi_mat,'reltol', reltol,'maxiter', maxiter, 'Minv', Mi_inv);
toc; fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );

%% 
u_i_alpha=apply_boundary_conditions_solution( Ui_mat, tensor_to_array(G), P_I, P_B );
[u,xi]=pce_field_realization( u_i_alpha, I_u );

[k]=kl_pce_field_realization( k_i_k, k_k_alpha, I_k, xi );
[f]=kl_pce_field_realization( f_i_k, f_k_alpha, I_f, xi );
[g]=kl_pce_field_realization( g_i_k, g_k_alpha, I_g, xi );


% plot solutions fields and difference
mh=multiplot_init(2,2);
opts={'view', 3};
multiplot; plot_field(pos, els, u, opts{:} ); 
multiplot; plot_field(pos, els, k, opts{:} ); 
multiplot; plot_field(pos, els, f, opts{:} ); 
multiplot; plot_field(pos, els, g, opts{:} ); 
