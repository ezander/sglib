function cmpsol_voss_trunc_mode

clc

log_start( fullfile( log_file_base(), mfilename ) );
do_compare( 'model_voss_default', get_solve_options )
log_stop();

function opts=get_solve_options
opts={};
opts{end+1}=struct( 'longdescr', 'tensor solver: after trunc', 'trunc_mode', 'after', 'descr', 'after');
opts{end+1}=struct( 'longdescr', 'tensor solver: before trunc', 'trunc_mode', 'before', 'descr', 'before');
opts{end+1}=struct( 'longdescr', 'tensor solver: in operator trunc', 'trunc_mode', 'operator', 'descr', 'operator');
opts{end+1}=struct( 'longdescr', 'dynamic tensor solver', 'dyn', true, 'trunc_mode', 'operator', 'descr', 'dynamic');
