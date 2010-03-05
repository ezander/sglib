%% load or create the geomatry
geom=get_param( 'geom', '' );
if isempty(geom)
    N=get_param( 'N', 50 );
    [pos,els,bnd_nodes]=create_mesh_1d( 0, 1, N );
    G_N=mass_matrix( pos, els );
    stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};
    d=1;
else
    num_refine=get_param( 'num_refine', 1 );
    show_mesh=get_param( 'show_mesh', false );
    [pos,els,G_N]=load_pdetool_geom( geom, num_refine, show_mesh );
    N=size(pos,2);
    bnd_nodes=find_boundary( els, true );
    stiffness_func={@stiffness_matrix, {pos, els}, {1,2}}; % could be changed to a pdetool function
    d=2;
end

%% construct the conductivity random field k
% define stochastic expansion parameters
p_k=get_param( 'p_k', 4 );
m_k=get_param( 'm_k', 4 );
l_k=get_param( 'l_k', 4 );

% define the distribution (name, parameters, shift, scale)
dist_k=get_param( 'dist_k', {'beta', {4,2}, 0.1, 1.0 } );
stdnor_k=@(x)(gendist_stdnor(x,dist_k{:}));

% define the covariance of the field
lc_k=get_param( 'lc_k', 0.3 );
cov_k_func=get_param( 'cov_k_func', @gaussian_covariance );
cov_k=get_param( 'cov_k', {cov_k_func,{lc_k,1}} );

% expand the field
[k_i_k,k_k_alpha,I_k]=expand_field_kl_pce( stdnor_k, cov_k, pos, G_N, p_k, m_k, l_k );


%% construct the right hand side random field f 
% define stochastic expansion parameters
p_f=get_param( 'p_f', 3 );
m_f=get_param( 'm_f', 2 );
l_f=get_param( 'l_f', 4 );

% define the distribution
dist_f=get_param( 'dist_f', {'beta', {4,2}, 0, 1.0 } );
stdnor_f=@(x)(gendist_stdnor(x,dist_f{:}));

% define 
lc_f=get_param( 'lc_f', 0.6 );
cov_f_func=get_param( 'cov_f_func', @gaussian_covariance );
cov_f=get_param( 'cov_f', {cov_f_func,{lc_f,1}} );

[f_i_k,f_k_alpha,I_f]=expand_field_kl_pce( stdnor_f, cov_f, pos, G_N, p_f, m_f, l_f );


%% construct the (deterministic) boundary conditions g
% this defines the function g(x)=x_1
p_g=0;
m_g=0;
l_g=0;

select=@(x,n)(x(n,:)');
g_func={ select, {1}, {2} };
% dummy pce (just the mean)
g_i_alpha=funcall( g_func, pos);
I_g=multiindex(m_g,p_g);
% "null" kl expansion of g
[g_i_k,g_k_alpha]=pce_to_kl( g_i_alpha, I_g, l_g );


