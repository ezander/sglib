function show_dynamic_truncation_stats

if fasttest('get')
    model_medium_easy
else
    %model_large_easy
    model_medium_easy
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

reltol=1e-7;
abstol=1e-7;
solver_name='gsi';
eps=1e-7;
maxiter=17;


dynamic_eps=true;



upratio_delta=0.1;

dyneps_factor=1/10;
cache_script solve_by_gsolve_tensor
plot_solution_overview( '010_10', info)

dyneps_factor=1/4;
cache_script solve_by_gsolve_tensor
plot_solution_overview( '010_04', info)

dyneps_factor=1/2;
cache_script solve_by_gsolve_tensor
plot_solution_overview( '010_02', info)



upratio_delta=0.7;

dyneps_factor=1/10;
cache_script solve_by_gsolve_tensor
plot_solution_overview( '070_10', info)

dyneps_factor=1/4;
cache_script solve_by_gsolve_tensor
plot_solution_overview( '070_04', info)

dyneps_factor=1/2;
cache_script solve_by_gsolve_tensor
plot_solution_overview( '070_02', info)



upratio_delta=0.02;

dyneps_factor=1/10;
cache_script solve_by_gsolve_tensor
plot_solution_overview( '002_10', info)

dyneps_factor=1/4;
cache_script solve_by_gsolve_tensor
plot_solution_overview( '002_04', info)

dyneps_factor=1/2;
cache_script solve_by_gsolve_tensor
plot_solution_overview( '002_02', info)





function plot_solution_overview(model, info)
multiplot_init(1,1)
multiplot;
% Achtung: fieser hack here
while length(info.errvec)<length(info.resvec)
    info.errvec(end+1)=info.errvec(end);
end
plot( 10*log10(info.errvec), 'x-' ); legend_add( 'rel. error' );
plot( info.rank_sol_after, 'o-' ); legend_add( 'rank' );
plot( 10*log10(abs(1-info.updvec)), 'd-' ); legend_add( '|1-update ratio|' );
plot( 10*log10(info.epsvec), '*-' ); legend_add( 'epsilon' );
disp(info.errvec)
disp(info.rank_sol_after)
xlim([1,15])
ylim([-60,100])
h=legend;
legend(h, 'Location', 'NorthWest')

%logaxis( gca, 'y' )

save_figure( gca, {'dynamic_truncation_%s', model} );

