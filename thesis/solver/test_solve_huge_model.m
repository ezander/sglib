function test_solve_huge_model

%#ok<*NASGU>
%#ok<*NOPRT>
%#ok<*DEFNU>
%#ok<*ASGLU>
%#ok<*STOUT>
%#ok<*INUSL>
%#ok<*NODEF>
 
global U_mat_true Ui_mat_true
global U_mat Ui_mat info_pcg pcg_err eps
global U Ui info_tp tp_err
global U2 Ui2 info_tp2 tp_err2
global U3 Ui3 info_tp3 tp_err3
global U4 Ui4 info_tp4 tp_err4


clc
% rebuild_scripts
underline( 'accurate pcg' );
[U_mat_true, Ui_mat_true]=compute_by_pcg_accurate;

underline( 'approximate pcg' );
[U_mat, Ui_mat, info_pcg]=compute_by_pcg_approx( Ui_mat_true, 1e-3, false );
pcg_err=gvector_error( U_mat, U_mat_true, 'relerr', true )
eps=eps_from_error( pcg_err );

% underline( 'approximate prec pcg' );
% [U_mat2, Ui_mat2, info_pcg2]=compute_by_pcg_approx( Ui_mat_true, pcg_err, true );
% pcg_err2=gvector_error( U_mat2, U_mat_true, 'relerr', true ) 

underline( 'normal tensor solver' );
eps=eps*(1+rand(1)/100000);
profile on
[U, Ui, info_tp]=compute_by_tensor_simple( Ui_mat_true, eps, false, false );
profile viewer
tp_err=gvector_error( U, U_mat_true, 'relerr', true )

underline( 'dynamic tensor solver' );
[U2, Ui2, info_tp2]=compute_by_tensor_simple( Ui_mat_true, eps, false, true );
tp_err2=gvector_error( U2, U_mat_true, 'relerr', true )

underline( 'dynamic prec tensor solver' );
[U3, Ui3, info_tp3]=compute_by_tensor_simple( Ui_mat_true, eps/3, true, true );
tp_err3=gvector_error( U3, U_mat_true, 'relerr', true )

underline( 'prec tensor solver' );
[U4, Ui4, info_tp4]=compute_by_tensor_simple( Ui_mat_true, eps/3, true, false );
tp_err4=gvector_error( U4, U_mat_true, 'relerr', true )

pcg_err
info_pcg.time
%pcg_err2
%info_pcg2.time
tp_err
info_tp.time
tp_err2
info_tp2.time
tp_err3
info_tp3.time
tp_err4
info_tp4.time

keyboard

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

multiplot;
plot( tensor_modes( Ui ) )
%logaxis( gca, 'y' )

%keyboard

% R_vec_pcg6=operator_apply( Ki, Ui_vec_pcg6, 'residual', true, 'b', Fi_vec );
% R_vec_pcg2=operator_apply( Ki, Ui_vec_pcg2, 'residual', true, 'b', Fi_vec );
% gvector_norm( R_vec_pcg2 )/gvector_norm(Fi_vec)



function rebuild_scripts 
autoloader( loader_scripts, true, 'caller' );




function [U_mat, Ui_mat, info]=compute_by_pcg_accurate 

autoloader( loader_scripts, false, 'caller' );

[mu_fs_i,fs_i_k,sigma_fs_k,fs_k_alpha]=kl_pce_to_standard_form(f_i_k,f_k_alpha); 
C_f=covariance_matrix( pos, cov_f );
[r_i_k,sigma_f]=kl_solve_evp( C_f, G_N, 30 );
sigma_F=tensor_modes(F);
close
hold all
plot( sigma_f/sigma_f(1) )
plot( sigma_fs_k/sigma_fs_k(1) )
plot( sigma_F/sigma_F(1) )
drawnow;
reltol=1e-12; 
cache_script solve_by_gsolve_pcg;



function [U_mat, Ui_mat, info]=compute_by_pcg_approx( Ui_true, tol, prec ) 

autoloader( loader_scripts, false, 'caller' );
reltol=tol;
abstol=tol;
if prec
    [Mi_inv, Ki, Fi]=precond_operator( Mi_inv, Ki, Fi );
end
cache_script solve_by_gsolve_pcg;




function [U, Ui, info]=compute_by_tensor_simple( Ui_true, eps, prec, dyn )

autoloader( loader_scripts, false, 'caller' );
reltol=1e-16;
abstol=1e-16;
if prod(gvector_size(Fi))>1e10
    clear Ui_true
end
dynamic_eps=dyn;
if prec
    [Mi_inv, Ki, Fi]=precond_operator( Mi_inv, Ki, Fi );
end

cache_script solve_by_gsolve_simple_tensor;




function scripts=loader_scripts
%model='model_huge';
model='model_huge_easy';
%model='model_large';
%model='model_large_easy';
scripts={model; 'define_geometry'; 'discretize_model'; 'setup_equation' };

prefix=['.cache/' mfilename '_' model '_'];
for i=1:size(scripts,1)
    target=[prefix, scripts{i,1}, '.mat'];
    scripts{i,2}=target;
end



function eps=eps_from_error( pcg_err )
eps=pcg_err/1.5;
scale=10^(floor(log10(eps)))/10;
eps=roundat( eps, scale );



function [PMi_inv, PKi, PFi]=precond_operator( Mi_inv, Ki, Fi )
PKi=tensor_operator_compose( Mi_inv, Ki );
PMi_inv={speye(size(Ki{1,1})),speye(size(Ki{1,2}))};
PFi=tensor_operator_apply( Mi_inv, Fi );
