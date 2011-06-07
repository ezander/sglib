ws='caller';
maxiter=get_base_param( 'maxiter', 100, ws );
reltol=get_base_param( 'reltol', 1e-6, ws );
abstol=get_base_param( 'abstol', 1e-6, ws );
verbosity=get_base_param( 'verbosity', 1, ws );
trunc_mode=get_base_param( 'trunc_mode', 'operator', ws );
eps=get_base_param( 'eps', 1e-6, ws );
k_max=get_base_param( 'k_max', inf, ws );
upratio_delta=get_base_param( 'upratio_delta', 0.1, ws );
dynamic_eps=get_base_param( 'dynamic_eps', false, ws );

trunc.eps=eps;
trunc.k_max=k_max;
options={'reltol', reltol,'maxiter', maxiter, 'abstol', abstol, 'Minv', Mi_inv, 'verbosity', inf };
options=[options, {'trunc', trunc, 'trunc_mode', trunc_mode}];
options=[options, {'upratio_delta', upratio_delta, 'dynamic_eps', dynamic_eps}];
options=[options, solve_opts{:}];

if exist( 'Ui_true' )
    options=[options, {'solution', Ui_true}];
end

th=tic;
timers( 'resetall' );
profile( 'on' )

if verbosity>0; 
    fprintf( 'Solving (simple_tp): \n' ); 
end

[Ui,flag,info]=generalized_solve_simple( Ki, Fi, options{:});

info.solve_time=toc(th);
info.rank_K=size(Ki,1);
info.timers=timers( 'getall' );
profile( 'off' )
info.prof=profile('info');


U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );

if verbosity>0; 
    toc(th); 
    fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
end

compute_error_tensor
