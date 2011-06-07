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
if verbosity>0; 
    fprintf( 'Solving (simple): \n' ); 
end

[Ui_mat,flag,info]=generalized_solve_simple( Ki,Fi_mat, options{:});
U_mat=apply_boundary_conditions_solution( Ui_mat, tensor_to_array(G), P_I, P_B );
info.solve_time=toc(th);

if verbosity>0; 
    toc(th); 
    fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
end

pce_func1={@pce_field_realization, {U_mat, I_u}, {1,2}};
pce_func2={@kl_pce_solve_system, {k_i_k, k_k_alpha, I_k, f_i_k, f_k_alpha, I_f, g_i_k, g_k_alpha, I_g, stiffness_func, P_I, P_B}, {1,2,3,4,5,6,7,8,9,10,11,12} };
m=size(I_u,2);
randn('seed',1010);
info.errest_l2=pce_error_mc( pce_func1, pce_func2, m, 'num_mc', 100, 'block', 1, 'G', [] );
info.errest_L2=pce_error_mc( pce_func1, pce_func2, m, 'num_mc', 100, 'block', 1, 'G', G_N );
