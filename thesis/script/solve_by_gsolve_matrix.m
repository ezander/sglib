if ~exist( 'Fi_mat', 'var' )
    Fi_mat=tensor_to_array( Fi );
end
if ~exist( 'Mi_inv', 'var' )
    [Mi_inv, Mi]=stochastic_precond_mean_based(Ki);
end

ws='caller';
solver_common_opts;
options={'reltol', reltol, 'maxiter', maxiter, 'abstol', abstol, 'Minv', Mi_inv, 'verbosity', inf};
if exist( 'Ui_true' )
    options=[options, {'solution', Ui_true}];
end

vector_type='matrix';
solver_stats_start

switch solver_name
    case 'gsi'
        [Ui_mat,flag,info]=generalised_solve_simple( Ki, Fi_mat, options{:});
    case 'gpcg'
        [Ui_mat,flag,info]=generalised_solve_pcg( Ki, Fi_mat, options{:});
    otherwise
        % unknown solver
        keyboard
end

U_mat=apply_boundary_conditions_solution( Ui_mat, tensor_to_array(G), P_I, P_B );

solver_stats_end
compute_error

