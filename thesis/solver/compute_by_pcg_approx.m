function [U_mat, Ui_mat, info]=compute_by_pcg_approx( model, Ui_true, tol, prec ) 

autoloader( loader_scripts( model ), false, 'caller' );
reltol=tol;
abstol=tol;
if prec
    [Mi_inv, Ki, Fi]=precond_operator( Mi_inv, Ki, Fi );
end
cache_script solve_by_gsolve_pcg;
info.rank_K=size(Ki,1);
