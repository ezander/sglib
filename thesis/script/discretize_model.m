%% construct the conductivity random field k
% define stochastic expansion parameters
p_k=get_param( 'p_k', 4 );
m_k=get_param( 'm_k', 4 );
l_k=get_param( 'l_k', 4 );
eps_k=get_param( 'eps_k', 0 );


% define the distribution (name, parameters, shift, scale)
dist_k=get_param( 'dist_k', {'beta', {4,2}, 0.1, 1.0 } );
mean_k_func=get_param( 'mean_k_func', [] );
stdnor_k={@gendist_stdnor, dist_k};

% define the covariance of the field
lc_k=get_param( 'lc_k', 0.3 );
cov_k_func=get_param( 'cov_k_func', @gaussian_covariance );
cov_k=get_param( 'cov_k', {cov_k_func,{lc_k,1}} );

% expand the field
[k_i_k,k_k_alpha,I_k,l_k]=expand_field_kl_pce( stdnor_k, cov_k, pos, G_N, p_k, m_k, l_k, 'eps', eps_k, 'mean_func', mean_k_func );

%% construct the right hand side random field f 
% define stochastic expansion parameters
p_f=get_param( 'p_f', 3 );
m_f=get_param( 'm_f', 2 );
l_f=get_param( 'l_f', 4 );
eps_f=get_param( 'eps_f', 0 );

% define the distribution
dist_f=get_param( 'dist_f', {'beta', {4,2}, 0, 1.0 } );
mean_f_func=get_param( 'mean_f_func', [] );
stdnor_f={@gendist_stdnor, dist_f};

% define the covariance of the field
lc_f=get_param( 'lc_f', 0.6 );
cov_f_func=get_param( 'cov_f_func', @gaussian_covariance );
cov_f=get_param( 'cov_f', {cov_f_func,{lc_f,1}} );

[f_i_k,f_k_alpha,I_f,l_f]=expand_field_kl_pce( stdnor_f, cov_f, pos, G_N, p_f, m_f, l_f, 'eps', eps_f, 'mean_func', mean_f_func );


%% Construct the Dirichlet boundary conditions g 
% note that we construct g on the whole domain and later take only its
% values on the boundary)

p_g=get_param( 'p_g', 1 );
m_g=get_param( 'm_g', 0 );
l_g=get_param( 'l_g', 0 );
eps_g=get_param( 'eps_g', 0 );

% define the distribution
dist_g=get_param( 'dist_g', {'normal', {0,1}, 0, 1.0 } );
mean_g_func=get_param( 'mean_g_func', [] );
stdnor_g={@gendist_stdnor, dist_g};

% define the covariance of the field
lc_g=get_param( 'lc_g', 100 );
cov_g_func=get_param( 'cov_g_func', @gaussian_covariance );
cov_g=get_param( 'cov_g', {cov_f_func,{lc_g,1}} );

[g_i_k,g_k_alpha,I_g,l_g]=expand_field_kl_pce( stdnor_g, cov_g, pos, G_N, p_g, m_g, l_g, 'eps', eps_g, 'mean_func', mean_g_func );
g_i_k=clear_non_boundary_values( g_i_k, bnd_nodes );

%% Construct the Neumann boundary conditions h
% note that we construct h on the whole domain and later take only its
% values on the boundary)

p_h=get_param( 'p_h', 1 );
m_h=get_param( 'm_h', 0 );
l_h=get_param( 'l_h', 0 );
eps_h=get_param( 'eps_h', 0 );

% define the distribution
dist_h=get_param( 'dist_h', {'normal', {0,1}, 0, 1.0 } );
mean_h_func=get_param( 'mean_h_func', [] );
stdnor_h={@gendist_stdnor, dist_h};

% define the covariance of the field
lc_h=get_param( 'lc_h', 100 );
cov_h_func=get_param( 'cov_h_func', @gaussian_covariance );
cov_h=get_param( 'cov_h', {cov_f_func,{lc_h,1}} );

[h_i_k,h_k_alpha,I_h,l_h]=expand_field_kl_pce( stdnor_h, cov_h, pos, G_N, p_h, m_h, l_h, 'eps', eps_h, 'mean_func', mean_h_func );


