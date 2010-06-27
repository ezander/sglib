clc
clear all

global lastr
lastr=nan;

% set default parameters
defaults=struct();
defaults.N=51;

% set parameters to vary
variable.eps=10.^-(0:0.5:14);
variable.mode={'operator', 'before', 'after'};
variable.r={0.00237, 0.00274, 0.00307, 0.00335, 0.00362, 0.00387 };

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

% run parameter study
ps_options={'cache', true, 'cache_file', mfilename };
ps_results=param_study( 'do_artmod_simple', variable, defaults, fields, ps_options{:} );

print_results( variable, fields, ps_results );

1;

%write_tex_tabular( '', ps_results.M, 'row_values', variable.m, 'col_values', variable.p, 'table_format', '%d' )
%write_tex_tabular( 'tab.tex', ps_results.M, 'row_values', variable.m,
%'col_values', variable.p, 'table_format', '%d' )
%write_tex_tabular( 'tab.tex', ps_results.M, 'col_values', variable.p, 'hline', true, 'table_format', '$a^{10}$ %d' )
