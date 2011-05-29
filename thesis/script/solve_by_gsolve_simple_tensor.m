maxiter=get_base_param( 'maxiter', 100, 'caller' );
reltol=get_base_param( 'reltol', 1e-6, 'caller' );
abstol=get_base_param( 'abstol', 1e-6, 'caller' );
verbosity=get_base_param( 'verbosity', 1, 'caller' );
trunc_mode=get_base_param( 'trunc_mode', 'operator', 'caller' );
eps=get_base_param( 'eps', 1e-6, 'caller' );
k_max=get_base_param( 'k_max', inf, 'caller' );
upratio_delta=get_base_param( 'upratio_delta', 0.1 );
dynamic_eps=get_base_param( 'dynamic_eps', false );

trunc.eps=eps;
trunc.k_max=k_max;
options={'reltol', reltol,'maxiter', maxiter, 'abstol', abstol, 'Minv', Mi_inv, 'verbosity', inf };
options=[options, {'trunc', trunc, 'trunc_mode', trunc_mode}];
options=[options, {'upratio_delta', upratio_delta, 'dynamic_eps', dynamic_eps}];

if exist( 'Ui_true' )
    options=[options, {'solution', Ui_true}];
end

th=tic; 
if verbosity>0; 
    fprintf( 'Solving (simple_tp): \n' ); 
end
[Ui,flag,info]=generalized_solve_simple( Ki, Fi, options{:});
info.solve_time=toc(th);

U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );

if verbosity>0; 
    toc(th); 
    fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
end
