function [X,flag,info,stats]=tensor_operator_solve_pcg( A, F, varargin )

options=varargin2options( varargin );
[M,options]=get_option( options, 'M', [] );
[Minv,options]=get_option( options, 'Minv', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[truncate_options,options]=get_option( options, 'truncate_options', struct() );
[trunc_mode,options]=get_option( options, 'trunc_mode', 2 );
[vareps,options]=get_option( options, 'vareps', false );
[eps,options]=get_option( options, 'eps', 0 );
[stats,options]=get_option( options, 'stats', struct() );
[stats_func,options]=get_option( options, 'stats_func', [] );
check_unsupported_options( options, mfilename );


pass_options={...
    'abstol', abstol,...
    'reltol', reltol,...
    'maxiter', maxiter,...
    'stats', stats,...
    };

if ~isempty(stats_func)
    pass_options=[pass_options {'stats_func', stats_func}];
end


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


% needs to become more intelligent
% pcg needs to pass stats to truncate function
truncate_func={@tensor_truncate, {'eps', eps}};
pass_options=[pass_options {'truncate_func', truncate_func}];
%truncate_options
%trunc_mode
%vareps


[X,flag,info,stats]=generalized_solve_pcg( A, F, pass_options{:} );
