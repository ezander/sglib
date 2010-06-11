function [X,flag,info,stats]=tensor_operator_solve_simple( A, F, varargin )

%% parse options
options=varargin2options( varargin );
[M,options]=get_option( options, 'M', [] );
[Minv,options]=get_option( options, 'Minv', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );

[trunc.eps,options]=get_option( options, 'eps', 0 );
[trunc.k_max,options]=get_option( options, 'k_max', 1000 );
[trunc.trunc_mode,options]=get_option( options, 'trunc_mode', 3 );
[trunc.vareps,options]=get_option( options, 'vareps', false );
[trunc.relcutoff,options]=get_option( options, 'relcutoff', true );
[trunc.vareps_threshold,options]=get_option( options, 'vareps_threshold', 0.1 );
[trunc.vareps_reduce,options]=get_option( options, 'vareps_reduce', 0.1 );
[trunc.show_reduction,options]=get_option( options, 'show_reduction', false );

[stats,options]=get_option( options, 'stats', struct() );
[stats_func,options]=get_option( options, 'stats_func', [] );
check_unsupported_options( options, mfilename );

%% options to just pass on to the solver
pass_options={...
    'abstol', abstol,...
    'reltol', reltol,...
    'maxiter', maxiter,...
    'stats', stats,...
    };

if ~isempty(stats_func)
    pass_options=[pass_options {'stats_func', stats_func}];
end

%% generate tensor prod preconditioner 
if ~isempty(M)
    if isempty(Minv)
        Minv=stochastic_preconditioner_deterministic( M );
    else
        error( 'M and Minv cannot be specified both' );
    end
end
pass_options=[pass_options {'Minv', Minv}];


%% generate truncation options
% needs to become more intelligent
% pcg needs to pass stats to truncate function


trunc_med=trunc;
trunc_med.eps=trunc.eps/3;
trunc_med.k_max=1.5*trunc.k_max;

truncate_strong={@tensor_truncate_variable, {trunc}, {2}};
truncate_med={@tensor_truncate_fixed, {trunc_med}, {2}};
truncate_zero={@tensor_truncate_zero, {trunc}, {2}};

if is_tensor(F)
    switch trunc.trunc_mode
        case 1 % after preconditioning
            truncate_operator_func=truncate_zero;
            truncate_before_func=truncate_zero;
            truncate_after_func=truncate_strong;
        case 2 % before preconditioning
            truncate_operator_func=truncate_strong;
            truncate_before_func=truncate_med;
            truncate_after_func=truncate_med;
        case 3 % in the operator
            truncate_operator_func={@tensor_truncate_variable, {trunc}, {2}};
            truncate_before_func={@tensor_truncate_variable, {trunc}, {2}};
            truncate_after_func={@tensor_truncate_variable, {trunc}, {2}};
    end
    %pass_options=[pass_options {'truncate_func', truncate_func}]
    pass_options=[pass_options {'truncate_operator_func', truncate_operator_func}];
    pass_options=[pass_options {'truncate_before_func', truncate_before_func}];
    pass_options=[pass_options {'truncate_after_func', truncate_after_func}];
    %pass_options=[pass_options {'truncate_zero_func', truncate_zero_func}];
end

%% call pcg
[X,flag,info,stats]=generalized_solve_simple( A, F, pass_options{:} );


