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


[u_i_k, u_k_alpha]=tensor_to_kl( U, false );
pce_func1={@kl_pce_field_realization, {u_i_k, u_k_alpha, I_u}, {1,2,3}};
pce_func2={@kl_pce_solve_system, {k_i_k, k_k_alpha, I_k, f_i_k, f_k_alpha, I_f, g_i_k, g_k_alpha, I_g, stiffness_func, P_I, P_B}, {1,2,3,4,5,6,7,8,9,10,11,12} };
m=size(I_u,2);
randn('seed',1010);
info.errest_l2=pce_error_mc( pce_func1, pce_func2, m, 'num_mc', 100, 'block', 1, 'G', [] );
info.errest_L2=pce_error_mc( pce_func1, pce_func2, m, 'num_mc', 100, 'block', 1, 'G', G_N );
