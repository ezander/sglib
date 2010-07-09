function study_simple_solver_artmod

global lastr
lastr=nan;

% variable.eps=10.^-(0:0.5:14);
% variable.mode={'operator', 'before', 'after'};
% variable.r={0.00237, 0.00274, 0.00307, 0.00335, 0.00362, 0.00387 };


% set return fields
fields={...
    {'info','info'}, ...
    {'resvec','info.resvec'}, ...
    {'err', 'curr_err'}, ...
    {'res', 'info.relres/gvector_norm(F)'}, ...
    {'time', 'tt'}, ...
    {'rank', 'info.rank_sol_after' }, ...
    {'modes', 'tensor_modes( X )' }, ...
    {'flag','flag'}, ...
    {'iter','info.iter'}, ...
    {'cmptime','cmptime'}, ...
    };

% set parameters
defaults=struct();
defaults.N=51;
variable.eps=10.^-(0:0.5:14);
variable.r=[0.00237, 0.00387];
variable.mode={'operator'};

% run parameter study
ps_options={'cache', true, 'cache_file', [mfilename '-ps1'] };
ps_results=param_study( 'do_artmod_simple', variable, defaults, fields, ps_options{:} );




