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
[stats,options]=get_option( options, 'stats', struct() );
[stats_gatherer,options]=get_option( options, 'stats_gatherer', @gather_stats_def );
check_unsupported_options( options, mfilename );

pass_options={...
    'M', M, ...
    'Minv', Minv,...
    'abstol', abstol,...
    'reltol', reltol,...
    'maxiter', maxiter,...
    'stats', stats,...
    'stats_gatherer', stats_gatherer...
    };


%truncate_options
%trunc_mode
%vareps
if ~isempty(M)
    warning('blah'); %#ok<WNTAG>
    keyboard;
end

[X,flag,info,stats]=generalized_solve_pcg( A, F, pass_options{:} );
