function show_ranks_res_and_solution

if fasttest('get')
    model_medium_easy
else
    model_large_easy
end
close
multiplot_init(2,2)

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
info.rho=rho;
plot_solution_overview( 'basic', info, maxiter-1 )
save info1 info

save foo  Mi Mi_inv Ki Fi
[Mi_inv, Ki, Fi]=precondition_system( Mi, Mi_inv, Ki, Fi, 'inside' );
cache_script solve_by_gsolve_tensor
info.norm_U=gvector_norm(Ui);
plot_solution_overview( 'inside', info, maxiter-1 )
save info2 info

load foo  Mi Mi_inv Ki Fi
ilu_options={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
[Mi_inv, Ki, Fi]=precondition_system( Mi, Mi_inv, Ki, Fi, 'ilu', ilu_options );
cache_script solve_by_gsolve_tensor
info.norm_U=gvector_norm(Ui);
plot_solution_overview( 'ilu', info, maxiter-1 )


info3=info;
load info2 info
info2=info;
load info1 info
info1=info;
plot_error(info1, info2, info3, maxiter-1)




function plot_solution_overview(model, info, l)
rr=info.rank_res_before(1:l);
rs=info.rank_sol_after(1:l);
re = log(info.errvec(1:l))*10+120;

multiplot;
plot( rr, 'x-' ); legend_add( 'rank residual' );
plot( rs, 'o-.' ); legend_add( 'rank solution' );
%plot( re, '+-.' ); legend_add( 'log rel. error' );
xlabel('iteration')
ylabel('rank')
ylim([0, 200])
legend(legend, 'Location','NorthWest')
save_figure( gca, {'ranks_res_and_sol_%s', model} );

function plot_error(info1, info2, info3, l)
multiplot;
plot( info1.errvec(1:l), 'x-' ); legend_add( 'basic' );
plot( info2.errvec(1:l), 'o-.' ); legend_add( 'inside' );
plot( info3.errvec(1:l), '+--' ); legend_add( 'ilu' );
logaxis( gca, 'y' );
%plot( re, '+-.' ); legend_add( 'log rel. error' );
xlabel('iteration')
ylabel('error')
legend(legend, 'Location','NorthEast')
save_figure( gca, 'errors_by_prec_strat' );


