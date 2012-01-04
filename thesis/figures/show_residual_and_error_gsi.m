function ranks_res_and_solution

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

reltol=1e-6;
abstol=1e-6;
solver_name='gsi';


resvecs={};
errvecs={};
upratio_delta=1;
maxiter=30;

for eps=10.^-(2:0.5:5)
    cache_script solve_by_gsolve_tensor
    info.norm_U=gvector_norm(Ui);
    info.rho=rho
    resvecs{end+1}=info.resvec/info.resvec(1);
    errvecs{end+1}=info.errvec;
end

mh=multiplot_init(2,1)

multiplot;
for i=1:length(resvecs)
    plot(resvecs{i},'x-');
end
logaxis(gca,'y')
xlim([1,30])
xlabel( 'iteration' )
ylabel( 'residual' )
save_figure( mh(1), 'residual_by_iteration_gsi' );

multiplot;
for i=1:length(errvecs)
    plot(errvecs{i},'x-');
end
logaxis(gca,'y')
xlabel( 'iteration' )
ylabel( 'error' )
save_figure( mh(2), 'error_by_iteration_gsi' );

%plot_solution_overview( 'basic', info )







