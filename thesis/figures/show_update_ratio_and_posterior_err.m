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
plot_solution_overview( 'gsi_basic', info )
%return


solver_name='gpcg';
cache_script solve_by_gsolve_tensor
info.norm_U=gvector_norm(Ui);
info.rho=rho
plot_solution_overview( 'gpcg_basic', info )



function plot_solution_overview(model, info)
multiplot_init(1,1)
multiplot;
rho=info.rho;
errest=rho/(1-rho)*info.updnormvec/info.norm_U+info.epsvec;
% Achtung: fieser hack here
while length(info.errvec)<length(info.resvec)
    info.errvec(end+1)=info.errvec(end);
end
plot( info.errvec, 'x-' ); legend_add( 'rel. error' );
plot( errest, '*-' ); legend_add( 'error est.' );
plot( info.resvec/info.resvec(1), 'o-' ); legend_add( 'rel. residual' );
plot( info.updvec, 'd-' ); legend_add( 'update ratio' );
logaxis( gca, 'y' )
save_figure( gca, {'update_ratio_error_and_residual_%s', model} );

