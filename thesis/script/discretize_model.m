% identification
model=get_base_param( 'model', '<unknown>' );
strvarexpand( 'discretising: $model$' );

%% construct the conductivity random field k
% define stochastic expansion parameters

p_k=get_base_param( 'p_k', 4 );
m_k=get_base_param( 'm_k', 4 );
l_k=get_base_param( 'l_k', 4 );
eps_k=get_base_param( 'eps_k', 0 );


% define the distribution (name, parameters, shift, scale)
dist_k=get_base_param( 'dist_k', {'beta', {4,2}, 0.1, 1.0 } );
mean_k_func=get_base_param( 'mean_k_func', [] );
stdnor_k={@gendist_stdnor, dist_k};

% define the covariance of the field
lc_k=get_base_param( 'lc_k', 0.3 );
cov_k_func=get_base_param( 'cov_k_func', @gaussian_covariance );
cov_k=get_base_param( 'cov_k', {cov_k_func,{lc_k,1}} );

% expand the field
[k_i_k,k_k_alpha,I_k,l_k]=expand_field_kl_pce( stdnor_k, cov_k, pos_s, G_N_s, p_k, m_k, l_k, 'eps', eps_k, 'mean_func', mean_k_func );
% multiplot_init(2,1);
% multiplot;
% [kr1,xi]= kl_pce_field_realization( k_i_k, k_k_alpha, I_k );
% plot_field( pos_s, els_s, kr1 );
k_i_k=P_s*k_i_k;
% multiplot;
% [kr2]= kl_pce_field_realization( k_i_k, k_k_alpha, I_k, xi );
% plot_field( pos, els, kr2 );

%% construct the right hand side random field f 
% define stochastic expansion parameters
p_f=get_base_param( 'p_f', 3 );
m_f=get_base_param( 'm_f', 2 );
l_f=get_base_param( 'l_f', 4 );
eps_f=get_base_param( 'eps_f', 0 );

% define the distribution
dist_f=get_base_param( 'dist_f', {'beta', {4,2}, 0, 1.0 } );
mean_f_func=get_base_param( 'mean_f_func', [] );
stdnor_f={@gendist_stdnor, dist_f};

% define the covariance of the field
lc_f=get_base_param( 'lc_f', 0.6 );
cov_f_func=get_base_param( 'cov_f_func', @gaussian_covariance );
cov_f=get_base_param( 'cov_f', {cov_f_func,{lc_f,1}} );

[f_i_k,f_k_alpha,I_f,l_f]=expand_field_kl_pce( stdnor_f, cov_f, pos_s, G_N_s, p_f, m_f, l_f, 'eps', eps_f, 'mean_func', mean_f_func );
f_i_k=P_s*f_i_k;


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

[g_i_k,g_k_alpha,I_g,l_g]=expand_field_kl_pce( stdnor_g, cov_g, pos_s, G_N_s, p_g, m_g, l_g, 'eps', eps_g, 'mean_func', mean_g_func );
g_i_k=P_s*g_i_k;
g_i_k=clear_non_boundary_values( g_i_k, bnd_nodes );

%% Construct the Neumann boundary conditions h
% note that we construct h on the whole domain and later take only its
% values on the boundary)

p_h=get_base_param( 'p_h', 1 );
m_h=get_base_param( 'm_h', 0 );
l_h=get_base_param( 'l_h', 0 );
eps_h=get_base_param( 'eps_h', 0 );

% define the distribution
dist_h=get_base_param( 'dist_h', {'normal', {0,1}, 0, 1.0 } );
mean_h_func=get_base_param( 'mean_h_func', [] );
stdnor_h={@gendist_stdnor, dist_h};

% define the covariance of the field
lc_h=get_base_param( 'lc_h', 100 );
cov_h_func=get_base_param( 'cov_h_func', @gaussian_covariance );
cov_h=get_base_param( 'cov_h', {cov_f_func,{lc_h,1}} );

[h_i_k,h_k_alpha,I_h,l_h]=expand_field_kl_pce( stdnor_h, cov_h, pos_s, G_N_s, p_h, m_h, l_h, 'eps', eps_h, 'mean_func', mean_h_func );
h_i_k=P_s*h_i_k;


