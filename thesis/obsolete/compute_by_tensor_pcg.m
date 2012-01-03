function [U, Ui, info]=compute_by_tensor_pcg( model, Ui_true, eps, prec_strat, dyn, trunc_mode, solve_opts )
swallow( trunc_mode );

filename=cache_model( model );
load( filename );

modify_system

reltol=1e-16;
abstol=1e-16;
dynamic_eps=dyn;

[Mi_inv, Ki, Fi]=precondition_system( Mi, Mi_inv, Ki, Fi, prec_strat{:} );

if ~exist('trunc_mode', 'var')
    trunc_mode='operator';
end

cache_script solve_by_gsolve_pcg_tensor;
