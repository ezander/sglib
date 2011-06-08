function show_cmpsol_large_op_klterms

% compares performance for the two stage preconditioner for different
% settings of the ILU preconditioner

clc

log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_large_easy', get_solve_options, 'accurate', false )
log_stop();

function opts=get_solve_options
opts={};

ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
gss_opts={'longdescr', 'ilutp 2 row prec tensor solver', ...
    'prec', {'ilu', ilu_setup}, 'descr', 'ilutp 2e-2 row'};
pcg_opts={'longdescr', 'pcg', ...
    'descr', 'pcg', 'type', 'pcg'};


for l_k=2:10
    opts{end+1}=varargin2options( [pcg_opts {'mod_opts', {'l_k',l_k}}] );
    opts{end+1}=varargin2options( [gss_opts {'mod_opts', {'l_k',l_k}}] );
end

