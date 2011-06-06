function [U, Ui, info]=compute_by_tensor_simple( model, Ui_true, eps, prec, dyn, trunc_mode, solve_opts )
swallow( trunc_mode );

filename=cache_model( model );
load( filename );

reltol=1e-16;
abstol=1e-16;
if prod(gvector_size(Fi))>1e10
    clear Ui_true
end
dynamic_eps=dyn;
[Mi_inv, Ki, Fi]=precondition_system( Mi_inv, Ki, Fi, prec{:} );
if ~exist('trunc_mode', 'var')
    trunc_mode='operator';
end

cache_script solve_by_gsolve_simple_tensor;
