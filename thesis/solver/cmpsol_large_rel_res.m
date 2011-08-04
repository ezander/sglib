function cmpsol_large_rel_res

% compares performance of the gsi and pcg for different values of the
% target relative residual

clc

log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_large_easy', get_solve_options, 'accurate', true )
show_tex_table_2d(2, 'hl',[3]);
log_stop();

function opts=get_solve_options
%#ok<*AGROW>
opts={};

ilu_options={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };

gsi_std_opts={...
    'descr', 'gsi', ...
    'longdescr', 'gsi', ...
    };

gsi_dyn_opts={...
    'descr', 'gsi dyn', ...
    'longdescr', 'gsi dyn', ...
    'dyn', true, 'eps', 1e-8 };


gsi_ilu_opts={...
    'descr', 'gsi dyn ilu', ...
    'longdescr', 'gsi dyn ilu', ...
    'prec_strat', {'ilu', ilu_options}, ...
    'dyn', true, 'eps', 1e-8 };

pcg_mean_opts={...
    'descr', 'pcg', ...
    'longdescr', 'pcg', ...
    'type', 'pcg', ...
    };

pcg_kron_opts={...
    'descr', 'pcg kron', ...
    'longdescr', 'pcg kron', ...
    'type', 'pcg', ...
    'prec', 'kron' };


for tol=[ 1e-4, 3e-4, 1e-3, 3e-3, 1e-2]
    i=1;
    for def_opts={gsi_std_opts,gsi_dyn_opts,gsi_ilu_opts,pcg_mean_opts,pcg_kron_opts}
        extra={};
        if i==1
            extra={'eps', tol/100};
        end
        opts{end+1}=varargin2options( [def_opts{1}, {'tol',tol}, extra] ); 
        i=i+1;
    end
end

