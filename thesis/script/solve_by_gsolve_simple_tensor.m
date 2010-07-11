maxiter=get_base_param( 'maxiter', 100, 'caller' );
reltol=get_base_param( 'reltol', 1e-6, 'caller' );
abstol=get_base_param( 'abstol', 1e-6, 'caller' );
verbosity=get_base_param( 'verbosity', 1, 'caller' );
trunc_mode=get_base_param( 'trunc_mode', 'operator', 'caller' );
eps=get_base_param( 'eps', 1e-6, 'caller' );
k_max=get_base_param( 'k_max', inf, 'caller' );

trunc.eps=eps;
trunc.k_max=k_max;
options={'reltol', reltol,'maxiter', maxiter, 'abstol', abstol, 'Minv', Mi_inv, 'verbosity', inf };
options=[options, {'trunc', trunc, 'trunc_mode', trunc_mode}];
if exist( 'Ui_true' )
    options=[options, {'solution', Ui_true}];
end

th=tic; 
if verbosity>0; fprintf( 'Solving (simple_tp): \n' ); end

[Ui,flag,info]=generalized_solve_simple( Ki, Fi, options{:});
U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
info.solve_time=toc(th);

toc(th); fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
