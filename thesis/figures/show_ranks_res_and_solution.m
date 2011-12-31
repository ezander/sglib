function show_ranks_res_and_solution

if fasttest('get')
    model_medium_easy
else
    model_large_easy
end

define_geometry
is_neumann=make_spatial_func('x<x');

cache_script discretize_model
cache_script setup_equation
cache_script compute_contractivity
info.rho=rho;

reltol=1e-12;
abstol=1e-12;
solver_name='gpcg';
cache_script solve_by_gsolve_matrix
Ui_true=Ui_mat;

reltol=1e-8;
abstol=1e-8;
solver_name='gsi';
eps=1e-5;
maxiter=10;

cache_script solve_by_gsolve_tensor
info.norm_U=gvector_norm(Ui);
info.rho=rho
plot_solution_overview( 'basic', info )


[Mi_inv, Ki, Fi]=precondition_system( Mi_inv, Ki, Fi, 'inside' )
cache_script solve_by_gsolve_tensor
info.norm_U=gvector_norm(Ui);
plot_solution_overview( 'inside', info )



function plot_solution_overview(model, info)
rr=info.rank_res_before;
rs=info.rank_sol_after;
l=min(length(rr),length(rs));
rr=rr(1:l);
rs=rs(1:l);

close
multiplot_init(1,1)

multiplot;
plot( rr, 'x-' ); legend_add( 'rank residual' );
plot( rs, 'o-.' ); legend_add( 'rank solution' );
xlabel('iteration')
ylabel('rank')
ylim([0, 200])
legend(legend, 'Location','NorthWest')
save_figure( gca, {'ranks_res_and_sol_%s', model} );


