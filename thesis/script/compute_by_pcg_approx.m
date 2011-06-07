function [U_mat, Ui_mat, info]=compute_by_pcg_approx( model, Ui_true, tol ) 

filename=cache_model( model );
load( filename );

modify_system

reltol=tol;
abstol=tol;

solver_name='gpcg';
vector_type='matrix';

cache_script( @solve_by_gsolve );
