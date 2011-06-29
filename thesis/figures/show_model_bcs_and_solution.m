%function show_comparison_mc
% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

if true
    rebuild=get_base_param('rebuild', false);
    autoloader( {'model_medium'; 'define_geometry'; 'discretize_model'; 'setup_equation'; 'solve_by_standard_pcg'; 'solution_vec2kl'}, rebuild, 'caller' );
    rebuild=false;
else
    model_medium
    define_geometry
    discretize_model
    setup_equation
    solve_by_standard_pcg
    solution_vec2kl
end


% get solution via kl_pce field of solution u(x,xi)
[u,xi]=kl_pce_field_realization( u_i_k, u_k_alpha, I_u );


% get solution via solving the system with k(x,xi), f(x,xi) and g(x,xi) for
% the same xi as above
[k]=kl_pce_field_realization( k_i_k, k_k_alpha, I_k, xi );
[f]=kl_pce_field_realization( f_i_k, f_k_alpha, I_f, xi );
[g]=kl_pce_field_realization( g_i_k, g_k_alpha, I_g, xi );

K=funcall( stiffness_func, k );
Ki=apply_boundary_conditions_operator( K, P_I );
fi=apply_boundary_conditions_rhs( K, f, g, P_I, P_B );
ui=Ki\fi;
u2=apply_boundary_conditions_solution( ui, g, P_I, P_B );

% plot solutions fields and difference
mh=multiplot_init(2,2);
opts={'view', 3};
multiplot(mh,1); plot_field(pos, els, u, opts{:} ); 
multiplot(mh,2); plot_field(pos, els, u2, opts{:} ); 
multiplot(mh,3); plot_field(pos, els, u-u2, opts{:} ); 
same_scaling( mh );
%%


mh=multiplot_init(2,2);
opts={'view', 3};
[u_mean,u_var]=kl_pce_moments( u_i_k, u_k_alpha, I_u );

multiplot(mh,1); plot_field(pos, els, u_mean, opts{:} ); 
multiplot(mh,2); plot_field(pos, els, u_var, opts{:} ); 
%same_scaling( mh );

multiplot(mh,4); 
%

%model_medium
%define_geometry
%discretize_model
plot_boundary_conds( pos, els, 'zpos', g_i_k(:,1)', 'neumann_nodes', neumann_nodes, 'bndwidth', 2 )
axis tight
1

%%
save_figure( mh(1), 'mc_versus_sg-mc_sol', 'type', 'raster' );
save_figure( mh(2), 'mc_versus_sg-sg_sol', 'type', 'raster' );
save_figure( mh(3), 'mc_versus_sg-mc_sg_diff', 'type', 'raster' );


%%
pce_func1={@kl_pce_field_realization, {u_i_k, u_k_alpha, I_u}, {1,2,3}};
pce_func2={@kl_pce_solve_system, {k_i_k, k_k_alpha, I_k, f_i_k, f_k_alpha, I_f, g_i_k, g_k_alpha, I_g, stiffness_func, P_I, P_B}, {1,2,3,4,5,6,7,8,9,10,11,12} };
m=size(I_u,2);

G=G_N;
randn('seed',1010);
pce_error_mc( pce_func1, pce_func2, m, 'num_mc', 100, 'block', 1, 'G', G )
G=[];
randn('seed',1010);
pce_error_mc( pce_func1, pce_func2, m, 'num_mc', 100, 'block', 1, 'G', G )


