% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

if ~exist('u_i_k', 'var') || (exist('recompute', 'var') && recompute)
    recompute=false;

    geom='lshape';
    num_refine=1;

    m_f=5;
    p_f=3;
    l_f=40;
    lc_f=0.2;
    cov_f_func=@gaussian_covariance;
    dist_f={'uniform', {-1,1}, 0.0, 1 };

    m_k=5;
    p_k=4;
    l_k=40;
    lc_k=[0.2 0.01];
    cov_k_func=@exponential_covariance;
    dist_k={'beta', {4,2}, 0.1, 1.0 };
    
    p_u=2;
    
    build_model;
    discretize;
    solve_by_matrix;
end

modes=1:size(u_i_k,2);
mask=[];
mask=any(I_k,1); 
mask=any(I_f,1); 
fields={
    {f_i_k, f_k_alpha, I_f}, ...
    {k_i_k, k_k_alpha, I_k}, ...
    {g_i_k, g_k_alpha, I_g}, ...
    {u_i_k, u_k_alpha, I_u}
    };
for k=4:11; 
    fields=[fields {{u_i_k(:,k)}}]; 
end 

titles={'f','k','g','u', 'u_1', 'u_2', 'u_3', 'u_4'};
extra_options={ 'renderer', 'opengl' };

animate_fields( pos, els, fields, 'rows', -1, 'cols', -1, 'mask', mask, 'zrange', {}, 'titles', titles, extra_options{:} );


