clear
geom='square';
geom='card';
geom='lshape';

m_f=5;
p_f=3;
l_f=40;
lc_f=0.5;
cov_f_func=@gaussian_covariance;

m_k=5;
p_k=3;
l_k=40;
lc_k=[0.2 0.01];
cov_k_func=@exponential_covariance;

build_model;
%discretize_model_full_pce;

[I_k,I_f,I_g]=multiindex_combine( {I_k, I_f, I_g} );

fields={
    {f_i_k, f_k_alpha, I_f}, ...
    {k_i_k, k_k_alpha, I_k}, ...
    {g_i_k, g_k_alpha, I_g}, ...
    };

animate_fields( pos, els, fields, 'rows', 2, 'renderer', 'opengl', 'zrange', {}, 'titles', {'f','k','g',''} );
