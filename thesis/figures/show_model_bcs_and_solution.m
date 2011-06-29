function show_model_bcs_and_solution
% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

model_medium
define_geometry
discretize_model
setup_equation
solve_by_standard_pcg
solution_vec2mat



mh=multiplot_init(2,2);
opts={'view', 3};
[u_mean,u_var]=pce_moments( U_mat, I_u );

multiplot(mh,1); plot_field(pos, els, u_mean, opts{:}, 'show_mesh', true ); 
multiplot(mh,2); plot_field(pos, els, u_var, opts{:} ); 

multiplot(mh,3); 
plot_boundary_conds( pos, els, 'zpos', g_i_k(:,1)', 'neumann_nodes', neumann_nodes, 'bndwidth', 2 )
axis tight

%%
save_figure( mh(1), 'solution_mean', 'type', 'raster' );
save_figure( mh(2), 'solution_var', 'type', 'raster' );
save_figure( mh(3), 'boundary_conds', 'type', 'raster' );


