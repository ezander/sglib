function cmpsol_large_ilu_param

% compares performance for the two stage preconditioner for different
% settings of the ILU preconditioner

clc

log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_large_easy', get_solve_options )
show_tex_table(1);
log_stop();

function opts=get_solve_options
opts={};
opts{end+1}=varargin2options( {'longdescr', 'normal tensor solver', ...
    'descr', 'normal'} );

opts{end+1}=varargin2options( {'longdescr', 'prec tensor solver', ...
    'prec_strat', {'inside'}, 'descr', 'inside'} );

ilu_setup={'type', 'nofill'};
opts{end+1}=varargin2options( {'longdescr', 'ilu nofill prec tensor solver', ...
    'prec_strat', {'ilu', ilu_setup}, 'descr', 'ilu nofill'} );

ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'udiag', 1};
opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 prec tensor solver', ...
    'prec_strat', {'ilu', ilu_setup}, 'descr', 'ilutp 2e-2'} );

ilu_setup={'type', 'ilutp', 'droptol', 0.2e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 0.2 row prec tensor solver', ...
    'prec_strat', {'ilu', ilu_setup}, 'descr', 'ilutp 0.2e-2 row'} );

ilu_setup={'type', 'ilutp', 'droptol', 0.5e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 0.5 row prec tensor solver', ...
    'prec_strat', {'ilu', ilu_setup}, 'descr', 'ilutp 0.5e-2 row'} );

ilu_setup={'type', 'ilutp', 'droptol', 1e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 1 row prec tensor solver', ...
    'prec_strat', {'ilu', ilu_setup}, 'descr', 'ilutp 1e-2 row'} );

ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 row prec tensor solver', ...
    'prec_strat', {'ilu', ilu_setup}, 'descr', 'ilutp 2e-2 row'} );

ilu_setup={'type', 'ilutp', 'droptol', 4e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 4 row prec tensor solver', ...
    'prec_strat', {'ilu', ilu_setup}, 'descr', 'ilutp 4e-2 row'} );


ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 row prec tensor solver', ...
    'dyn', true, 'prec_strat', {'ilu', ilu_setup}, 'descr', 'ilutp 2e-2 row'} );

% ilu_setup=struct( 'type', 'nofill', 'milu', 'row', 'droptol', 2e-2 );
% ilu_setup=struct( 'type', 'ilutp', 'milu', 'row', 'droptol', 2e-2 );
