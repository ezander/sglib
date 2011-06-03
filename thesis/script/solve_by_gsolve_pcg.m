if ~exist( 'Fi_mat', 'var' )
    Fi_mat=tensor_to_array( Fi );
end
if ~exist( 'Mi_inv', 'var' )
    Mi_inv=stochastic_precond_mean_based(Ki);
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
timers( 'resetall' );
profile( 'on' )

th=tic; 
if verbosity>0; 
    fprintf( 'Solving (gpcg): ' ); 
end

[Ui_mat,flag,info]=generalized_solve_pcg( Ki, Fi_mat, options{:});

info.solve_time=toc(th);
info.timers=timers( 'getall' );
profile( 'off' )
info.prof=profile('info');

U_mat=apply_boundary_conditions_solution( Ui_mat, tensor_to_array(G), P_I, P_B );

if verbosity>0
    toc(th); 
    fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
end

