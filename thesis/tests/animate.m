% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

model_large;
mean_f_func=make_spatial_func( '0.6*(1-1*(x^2+y^2))' );
%l_f=10;
%l_k=10;
%num_refine=0;
%m_k=4;
%m_f=4;
m_g=4;
l_g=10;
lc_g=.3;
%mean_g_func=make_spatial_func('30*sin(2*pi*y)*cos(3*pi*x)');
mean_g_func=make_spatial_func('x+y');
%is_neumann=make_spatial_func('x>-0.01');

rebuild=get_base_param('rebuild', true);
autoloader( {'define_geometry'; 'discretize_model'; 'setup_equation'; 'solve_by_standard_pcg'}, rebuild );
rebuild=false;

U=apply_boundary_conditions_solution( Ui, tensor_to_array( G ), P_I, P_B );
[u_i_k, u_k_alpha]=pce_to_kl( U, I_u, 20, [], [] );

%% animate input and output random fields
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
titles={'f','k','g','u'};
for k=1:3:10; 
    fields=[fields, {{u_i_k(:,k)}}]; 
    titles=[titles, {sprintf( 'u_%d', k)} ];
end 

extra_options={ 'renderer', 'opengl', 'view_mode', [233, 30] };
%extra_options={ 'renderer', 'opengl', 'view_mode', 2 };
extra_options=[extra_options {'xlabels', 'x', 'ylabels', 'y' }];
% fields={
%     {k_i_k, k_k_alpha, I_k}
%     };
animate_fields( pos, els, fields, 'rows', -1, 'cols', -1, 'mask', mask, 'zrange', {}, 'titles', titles, extra_options{:} );


