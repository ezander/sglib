function [U, Ui, info]=compute_by_tensor_simple( model, Ui_true, eps, prec, dyn, trunc_mode )
swallow( trunc_mode );
autoloader( loader_scripts( model ), false, 'caller' );
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
info.rank_K=size(Ki,1);
