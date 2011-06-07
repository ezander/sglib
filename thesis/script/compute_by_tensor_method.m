function [U, Ui, info]=compute_by_tensor_method( model, solver_name, Ui_true, eps, prec, dyn, trunc_mode, solve_opts )
swallow( trunc_mode );

filename=cache_model( model );
load( filename );


reltol=1e-16;
abstol=1e-16;
dynamic_eps=dyn;

[Mi_inv, Ki, Fi]=precondition_system( Mi_inv, Ki, Fi, prec{:} );

if ~exist('trunc_mode', 'var')
    trunc_mode='operator';
end

vector_type='tensor';
modify_system

cache_script( @solve_by_gsolve );
