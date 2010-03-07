function [X,flag,info,stats]=tensor_operator_solve_pcg( A, F, varargin )

%% parse options
options=varargin2options( varargin );
[M,options]=get_option( options, 'M', [] );
[Minv,options]=get_option( options, 'Minv', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );

[trunc.eps,options]=get_option( options, 'eps', 0 );
[trunc.k_max,options]=get_option( options, 'k_max', 1000 );
[trunc.trunc_mode,options]=get_option( options, 'trunc_mode', 2 );
[trunc.vareps,options]=get_option( options, 'vareps', false );
[trunc.relcutoff,options]=get_option( options, 'relcutoff', true );
[trunc.vareps_threshold,options]=get_option( options, 'vareps_threshold', 0.1 );;
[trunc.vareps_reduce,options]=get_option( options, 'vareps_reduce', 0.1 );;

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
if isempty(Minv)
    if ~isempty(M)
        Minv=stochastic_preconditioner_deterministic( M );
    else
        % Ok, user doesn't want a preconditioner
    end
else
    if ~isempty(M)
        error( 'M and Minv cannot be specified both' );
    end
end
pass_options=[pass_options {'Minv', Minv}];


%% generate truncation options
% needs to become more intelligent
% pcg needs to pass stats to truncate function
truncate_func={@tensor_truncate_variable, {trunc}, {2}};
truncate_op_func={@tensor_truncate_zero, {trunc}, {2}};
pass_options=[pass_options {'truncate_func', truncate_func, 'truncate_op_func', truncate_op_func}];

%% call pcg
[X,flag,info,stats]=generalized_solve_pcg( A, F, pass_options{:} );


function U=tensor_truncate_fixed( T, trunc, stats )
U=tensor_truncate( T, 'eps', trunc.eps, 'k_max' );

function U=tensor_truncate_variable( T, trunc, stats )
U=tensor_truncate( T, 'eps', trunc.eps );

function U=tensor_truncate_zero( T, trunc )
k_max=min(tensor_size(T));
if tensor_rank(T)>k_max
    U=tensor_truncate( T, 'eps', 0, 'k_max', k_max );
else
    U=T;
end


