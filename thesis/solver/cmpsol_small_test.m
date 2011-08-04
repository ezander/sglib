function cmpsol_small_test
% only for testing whether all runs as it should using the small model so
% that its fast

clc
log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_small_easy', get_solve_options, 'accurate', true )
log_stop();

function opts=get_solve_options
opts={};
opts{end+1}=struct( 'longdescr', 'PCG', 'descr', 'PCG', 'type', 'pcg');
opts{end+1}=struct( 'longdescr', 'pcg tensor solver', 'descr', 'tpcg', 'type','gpcg');
opts{end+1}=struct( 'longdescr', 'normal tensor solver', 'descr', 'normal');


opts{end+1}=struct( 'longdescr', 'dynamic tensor solver', 'dyn', true, 'descr', 'dynamic');

ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 row prec tensor solver', ...
    'dyn', true, 'prec_strat', {'ilu', ilu_setup}, 'descr', 'dynilutp'} );


