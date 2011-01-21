function [U_mat, Ui_mat, info]=compute_by_pcg_approx( model, Ui_true, tol, precond_op ) 

filename=cache_model( model );
load( filename );

reltol=tol;
abstol=tol;
if precond_op
    [Mi_inv, Ki, Fi]=precond_operator( Mi_inv, Ki, Fi );
end
cache_script solve_by_gsolve_pcg;
info.rank_K=size(Ki,1);
