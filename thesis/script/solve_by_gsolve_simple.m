if ~exist( 'Fi_mat', 'var' )
    Fi_mat=tensor_to_array( Fi );
end
if ~exist( 'Mi_inv', 'var' )
    Mi_inv=stochastic_preconditioner_deterministic(Ki);
end

maxiter=get_base_param( 'maxiter', 100, 'caller' );
reltol=get_base_param( 'reltol', 1e-6, 'caller' );
abstol=get_base_param( 'abstol', 1e-6, 'caller' );
verbosity=get_base_param( 'verbosity', 1, 'caller' );

options={'reltol', reltol, 'maxiter', maxiter, 'abstol', abstol, 'Minv', Mi_inv, 'verbosity', inf};
if exist( 'Ui_true' )
    options=[options, {'solution', Ui_true}];
end

th=tic; 
if verbosity>0; fprintf( 'Solving (simple): \n' ); end

[Ui_mat,flag,info]=generalized_solve_simple( Ki,Fi_mat, options{:});
U_mat=apply_boundary_conditions_solution( Ui_mat, tensor_to_array(G), P_I, P_B );
info.solve_time=toc(th);

toc(th); fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
