function [U, Ui, info]=compute_by_tensor_simple( model, solver_type, Ui_true, eps, prec, dyn, trunc_mode, solve_opts )
swallow( trunc_mode );

filename=cache_model( model );
load( filename );

modify_system

reltol=1e-16;
abstol=1e-16;
dynamic_eps=dyn;

[Mi_inv, Ki, Fi]=precondition_system( Mi_inv, Ki, Fi, prec{:} );

if ~exist('trunc_mode', 'var')
    trunc_mode='operator';
end

switch  solver_type
    case 'tensor'
        cache_script solve_by_gsolve_simple_tensor;
    case 'tpcg'
        cache_script solve_by_gsolve_pcg_tensor;
end

