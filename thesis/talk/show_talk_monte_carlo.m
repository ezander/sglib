function show_talk_monte_carlo
% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

rebuild=false;
rebuild=get_base_param('rebuild', true);
autoloader( {'model_large'; 'define_geometry'; 'discretize_model'; 'setup_equation'; 'solve_by_pcg'; 'vector_to_tensor'}, rebuild, 'caller' );
rebuild=false;


rand( 'seed', 12345 );

for i=1:10
    % get solution via kl_pce field of solution u(x,xi)
    [u,xi]=kl_pce_field_realization( u_i_k, u_k_alpha, I_u );
    
    
    % get solution via solving the system with k(x,xi), f(x,xi) and g(x,xi) for
    % the same xi as above
    [k]=kl_pce_field_realization( k_i_k, k_k_alpha, I_k, xi );
    [f]=kl_pce_field_realization( f_i_k, f_k_alpha, I_f, xi );
    [g]=kl_pce_field_realization( g_i_k, g_k_alpha, I_g, xi );
    
    % plot solutions fields and difference
    mh=multiplot_init(3,1);
    opts={'view', 3};
    multiplot(mh,1); plot_field(pos, els, k, opts{:} );
    multiplot(mh,2); plot_field(pos, els, f, opts{:} );
    multiplot(mh,3); plot_field(pos, els, u, opts{:} );
    %same_scaling( mh );
    
    save_thesis_figure( mh(1), {'mc_k_%d', i} );
    save_thesis_figure( mh(2), {'mc_f_%d', i} );
    save_thesis_figure( mh(3), {'mc_u_%d', i} );
end
