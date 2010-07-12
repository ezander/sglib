function test_solve_huge_model

% clc
% rebuild_scripts

[U_mat_true, Ui_mat_true]=compute_by_pcg_accurate;

[U_mat, Ui_mat, info_pcg]=compute_by_pcg_approx( Ui_mat_true );
pcg_err=gvector_error( U_mat, U_mat_true, 'relerr', true )

eps=pcg_err/1.5;
scale=10^(floor(log10(eps)))/10;
eps=roundat( eps, scale );

[U, Ui, info_tp]=compute_by_tensor_simple( Ui_mat_true, eps );
tp_err=gvector_error( U, U_mat_true, 'relerr', true )

%%
close
multiplot_init(2,2)
multiplot
plot( info_tp.resvec, 'x-' ); legend_add( 'residual' );
plot( info_tp.errvec, 'x-' ); legend_add( 'error' );
plot( info_tp.updvec, 'x-' ); legend_add( 'update' );
logaxis( gca, 'y' )

multiplot;
plot( info_tp.rank_res_before, 'x-' ); legend_add( 'rank (before prec)' );
plot( info_tp.rank_sol_after, 'x-' ); legend_add( 'rank (after prec)' );

keyboard

% R_vec_pcg6=operator_apply( Ki, Ui_vec_pcg6, 'residual', true, 'b', Fi_vec );
% R_vec_pcg2=operator_apply( Ki, Ui_vec_pcg2, 'residual', true, 'b', Fi_vec );
% gvector_norm( R_vec_pcg2 )/gvector_norm(Fi_vec)

function rebuild_scripts
autoloader( loader_scripts, true, 'caller' );

function [U_mat, Ui_mat, info]=compute_by_pcg_accurate

autoloader( loader_scripts, false, 'caller' );
reltol=1e-12;
cache_script solve_by_gsolve_pcg;

function [U_mat, Ui_mat, info]=compute_by_pcg_approx( Ui_true )

autoloader( loader_scripts, false, 'caller' );
reltol=1e-3;
cache_script solve_by_gsolve_pcg;

function [U, Ui, info]=compute_by_tensor_simple( Ui_true, eps )

autoloader( loader_scripts, false, 'caller' );
reltol=1e-16;
abstol=1e-16;
%maxiter=3;
k_max=100;
if numel(Ui_true)>1e6
    clear Ui_true
end
%eps=3e-5;
%cache_script solve_by_gsolve_simple_tensor;
profile on
solve_by_gsolve_simple_tensor;
profile viewer
keyboard

function scripts=loader_scripts
model='model_huge';
%model='model_large';
scripts={model; 'define_geometry'; 'discretize_model'; 'setup_equation' };

prefix=['.cache/' mfilename '_' model '_'];
for i=1:size(scripts,1)
    target=[prefix, scripts{i,1}, '.mat'];
    scripts{i,2}=target;
end

