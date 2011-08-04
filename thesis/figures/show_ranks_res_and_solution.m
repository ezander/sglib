function show_ranks_res_and_solution

if fasttest('get')
    model_medium_easy
else
    model_large_easy
end

define_geometry
cache_script discretize_model
cache_script setup_equation
cache_script compute_contractivity
info.rho=rho;

reltol=1e-12;
abstol=1e-12;
solver_name='gpcg';
cache_script solve_by_gsolve_matrix
Ui_true=Ui_mat;

reltol=1e-3;
abstol=1e-3;
solver_name='gsi';
eps=1e-4;

cache_script solve_by_gsolve_tensor
info.norm_U=gvector_norm(Ui);
info.rho=rho
plot_solution_overview( 'basic', info )


[Mi_inv, Ki, Fi]=precondition_system( Mi_inv, Ki, Fi, 'inside' )
cache_script solve_by_gsolve_tensor
info.norm_U=gvector_norm(Ui);
plot_solution_overview( 'inside', info )



function plot_solution_overview(model, info)
close
multiplot_init(1,1)

multiplot;
plot( info.rank_res_before, 'x-' ); legend_add( 'rank residuum' );
plot( info.rank_sol_after, 'x-' ); legend_add( 'rank solution' );
save_figure( gca, {'ranks_res_and_sol_%s', model} );


