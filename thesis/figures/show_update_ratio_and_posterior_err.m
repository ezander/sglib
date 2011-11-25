function show_update_ratio_and_posterior_err

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

reltol=1e-3;
abstol=1e-3;
solver_name='gsi';
eps=1e-4;
maxiter=20;
upratio_delta=1;

cache_script solve_by_gsolve_tensor
info.norm_U=gvector_norm(Ui);
info.rho=rho
plot_solution_overview( 'gsi_basic', info, 0 )
plot_solution_overview( 'gsi_basic_10pc', info, 0.1 )
plot_solution_overview( 'gsi_basic_1pc', info, 0.01 )


solver_name='gpcg';
cache_script solve_by_gsolve_tensor
info.norm_U=gvector_norm(Ui);
info.rho=rho
plot_solution_overview( 'gpcg_basic', info, false )



function plot_solution_overview(model, info, delta)
multiplot_init(1,1)
multiplot;
rho=info.rho;
errest=rho/(1-rho)*info.updnormvec/info.norm_U+info.epsvec;
% Achtung: fieser hack here
while length(info.errvec)<length(info.resvec)
    info.errvec(end+1)=info.errvec(end);
end
plot( info.errvec, 'x-' ); legend_add( 'rel. error' );
if delta==0
    plot( errest, '*-' ); legend_add( 'error est.' );
    plot( info.resvec/info.resvec(1), 'o-' ); legend_add( 'rel. residual' );
end
plot( info.updvec, 'd-' ); legend_add( 'update ratio' );

logaxis( gca, 'y' )

if delta
    stop=find(abs(1-info.updvec)>delta, 1)
    yl=ylim;
    plot([stop,stop], yl, 'k--')
    xl=xlim;
    plot(xl, [1-delta, 1-delta], 'k--')
    xlabel('k')
end

save_figure( gca, {'update_ratio_error_and_residual_%s', model} );

