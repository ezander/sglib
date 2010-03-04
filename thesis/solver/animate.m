if exist('recompute') && recompute
    clear
    geom='square';
    geom='card';
    geom='lshape';
    recompute=false;
    
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
    dist_k=get_param( 'dist_k', {'beta', {4,2}, 0.4, 1.0 } );
    

    p_f=2;
    p_k=3;
    num_refine=0;
    
    
    build_model;
    discretize;
    solve_by_matrix;
end

%[I_k,I_f,I_g]=multiindex_combine( {I_k, I_f, I_g} );

modes=1:10;
fields={
    {f_i_k, f_k_alpha, I_f}, ...
    {k_i_k, k_k_alpha, I_k}, ...
    {g_i_k, g_k_alpha, I_g}, ...
    {u_i_k(:,modes), u_k_alpha(modes,:), I_u}, ...
    };

animate_fields( pos, els, fields, 'rows', 2, 'renderer', 'opengl', 'zrange', {}, 'titles', {'f','k','g',''} );
plot_field( pos, els, u_i_k(:,3) )
