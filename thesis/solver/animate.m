% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

if ~exist('u_i_k', 'var') || (exist('recompute', 'var') && recompute)
    recompute=false;

    model_large;
    %l_f=10;
    %l_k=10;
    %p_u=3;
       
    underline('build_model');
    build_model;
    
    underline('discretize');
    discretize;
    
    underline('solve_by_???');
    use_pcg=true;
    %solve_by_matrix;
    solve_by_tensor2;
end

modes=1:size(u_i_k,2);
mask=any(I_f,1); 
mask=any(I_k,1); 
mask=[];
fields={
    {f_i_k, f_k_alpha, I_f}, ...
    {k_i_k, k_k_alpha, I_k}, ...
    {g_i_k, g_k_alpha, I_g}, ...
    {u_i_k, u_k_alpha, I_u}
    };
titles={'f','k','g','u'};
for k=1:3:10; 
    fields=[fields, {{u_i_k(:,k)}}]; 
    titles=[titles, {sprintf( 'u_%d', k)} ];
end 

extra_options={ 'renderer', 'opengl' };

animate_fields( pos, els, fields, 'rows', -1, 'cols', -1, 'mask', mask, 'zrange', {}, 'titles', titles, extra_options{:} );


