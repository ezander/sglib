function cmpsol_large_precond_strats

% compares performance for the two stage preconditioner for different
% settings of the ILU preconditioner
clc

log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_large_easy', get_solve_options )
log_stop();


function opts=get_solve_options
opts={};
opts{end+1}=varargin2options( {'longdescr', 'normal tensor solver', ...
    'descr', 'normal'} );

opts{end+1}=varargin2options( {'longdescr', 'prec tensor solver', ...
    'prec_strat', {'inside'}, 'descr', 'prec'} );

ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 row prec tensor solver', ...
    'prec_strat', {'ilu', ilu_setup}, 'descr', 'ilutp 2e-2 row'} );

for i=1:length(opts)
    o=opts{i};
    o.dyn=true;
    o.descr=[o.descr ' dyn'];
    o.longdescr=[o.longdescr ' dyn'];
    opts(end+1)={o};
end

%opts=opts(2:2);
% ilu_setup=struct( 'type', 'nofill', 'milu', 'row', 'droptol', 2e-2 );
% ilu_setup=struct( 'type', 'ilutp', 'milu', 'row', 'droptol', 2e-2 );
