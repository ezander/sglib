% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

%% setup and solve the model
if ~exist('u_i_k', 'var') || (exist('recompute', 'var') && recompute)
    recompute=false;

    underline('model_large');
    model_large;
    mean_f_func={@spatial_function, {'0.6*(1-1*(x^2+y^2))'}, {1}};
    %l_f=10;
    %l_k=10;
    %num_refine=0;
    %m_k=4;
    %m_f=4;
    m_g=2;
    l_g=2;
    mean_g_func=make_spatial_function('x+y');
    is_neumann=make_spatial_function('x>-0.01');
    
    underline('discretize_model');
    discretize_model;
        
    underline('setup_equation');
    setup_equation;
    
    underline('solve_by_pcg');
    solve_by_pcg;
end

%% animate input and output random fields
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

extra_options={ 'renderer', 'opengl', 'view_mode', [233, 30] };
extra_options=[extra_options {'xlabels', 'x', 'ylabels', 'y' }];

animate_fields( pos, els, fields, 'rows', -1, 'cols', -1, 'mask', mask, 'zrange', {}, 'titles', titles, extra_options{:} );


