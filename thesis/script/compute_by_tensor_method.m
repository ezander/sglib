function [U, Ui, info]=compute_by_tensor_method( model, xprec, solver_name, Ui_true, tol, eps, prec_strat, dyn, trunc_mode, solve_opts, mod_opts ) %#ok<INUSD,INUSL>

filename=cache_model( model );
load( filename );

reltol=tol;
abstol=tol;

dynamic_eps=dyn;

vector_type='tensor';

prec=xprec;
modify_system
[Mi_inv, Ki, Fi]=precondition_system( Mi, Mi_inv, Ki, Fi, prec_strat{:} );

cache_script( @solve_by_gsolve );
