function show_cmpsol_large_op_klterms

% compares performance for the two stage preconditioner for different
% settings of the ILU preconditioner

clc

log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_large_easy', get_solve_options )
log_stop();

function opts=get_solve_options
opts={};

ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
def_opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 row prec tensor solver', ...
    'prec', {'ilu', ilu_setup}, 'descr', 'ilutp 2e-2 row'} );

opts{end+1}=[def_opts {'l_k',1}];
opts{end+1}=[def_opts {'l_k',2}];
opts{end+1}=[def_opts {'l_k',3}];
opts{end+1}=[def_opts {'l_k',4}];
opts{end+1}=[def_opts {'l_k',5}];
%opts{end+1}=[def_opts {'l_k',8}];
%opts{end+1}=[def_opts {'l_k',10}];
%opts{end+1}=[def_opts {'l_k',15}];


