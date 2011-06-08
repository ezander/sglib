function [U, Ui, info]=compute_by_tensor_method( model, solver_name, Ui_true, tol, eps, prec, dyn, trunc_mode, solve_opts, mod_opts ) %#ok<INUSD,INUSL>

filename=cache_model( model );
load( filename );

reltol=tol;
abstol=tol;

[Mi_inv, Ki, Fi]=precondition_system( Mi_inv, Ki, Fi, prec{:} );
dynamic_eps=dyn;

vector_type='tensor';

modify_system

cache_script( @solve_by_gsolve );
