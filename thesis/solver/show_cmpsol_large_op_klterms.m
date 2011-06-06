function show_cmpsol_large_ilu_param

% compares performance for the two stage preconditioner for different
% settings of the ILU preconditioner

clc

log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_large_easy', get_solve_options )
log_stop();

function opts=get_solve_options
opts={};
