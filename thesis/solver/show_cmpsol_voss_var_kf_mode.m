function show_cmpsol_voss_var_kf_mode

clc

log_start( fullfile( log_file_base(), mfilename ) );
do_compare( 'model_voss_small_f', get_solve_options )
do_compare( 'model_voss_large_f', get_solve_options )
do_compare( 'model_voss_small_k', get_solve_options )
do_compare( 'model_voss_large_k', get_solve_options )
log_stop();

function opts=get_solve_options
opts={};
opts{end+1}=struct( 'longdescr', 'dynamic tensor solver', 'dyn', true, 'trunc_mode', 'operator', 'descr', 'dynamic');
