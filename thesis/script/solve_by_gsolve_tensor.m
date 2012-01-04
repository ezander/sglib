ws='caller';
solver_common_opts;

trunc_mode=get_base_param( 'trunc_mode', 'operator', ws );
eps=get_base_param( 'eps', 1e-6, ws );
k_max=get_base_param( 'k_max', inf, ws );
dynamic_eps=get_base_param( 'dynamic_eps', false, ws );
upratio_delta=get_base_param( 'upratio_delta', 0.1, ws );
dyneps_factor=get_base_param( 'dyneps_factor', 0.5, ws );
solve_opts=get_base_param( 'solve_opts', {}, ws );
solver_name=get_base_param( 'solver_name', 'gsi', ws );

trunc.eps=eps;
trunc.k_max=k_max;
options={};
options=[options, {'abstol', abstol, 'reltol', reltol,'maxiter', maxiter }];
options=[options, {'trunc_mode', trunc_mode, 'trunc', trunc}];
options=[options, {'dynamic_eps', dynamic_eps, 'upratio_delta', upratio_delta, 'dyneps_factor', dyneps_factor}];
options=[options, solve_opts{:}];
options=[options, {'verbosity', verbosity, 'Minv', Mi_inv }];

if exist( 'Ui_true' )
    options=[options, {'solution', Ui_true}];
end

vector_type='tensor';
solver_stats_start

switch solver_name
    case 'gsi'
        [Ui,flag,info]=generalised_solve_simple( Ki, Fi, options{:});
    case 'gpcg'
        [Ui,flag,info]=generalised_solve_pcg( Ki, Fi, options{:});
    otherwise
        % unknown solver
        keyboard
end
U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );

solver_stats_end
if ~(iscell(U) && length(U)>2)
    compute_error
end
