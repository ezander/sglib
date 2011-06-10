function [U_mat, Ui_mat, info]=compute_by_pcg_approx( model, xprec, Ui_true, tol, solve_opts, mod_opts )  %#ok<INUSL,INUSD>

filename=cache_model( model );
load( filename );

reltol=tol;
abstol=tol;

solver_name='gpcg';
vector_type='matrix';

prec=xprec;
modify_system

cache_script( @solve_by_gsolve );
