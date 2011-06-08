function show_cmpsol_large_trunc_mode

clc
log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_large_easy', get_solve_options )
log_stop();

function opts=get_solve_options
opts={};
opts{end+1}=struct( 'longdescr', 'tensor solver: after trunc', 'trunc_mode', 'after', 'descr', 'after');
opts{end+1}=struct( 'longdescr', 'tensor solver: before trunc', 'trunc_mode', 'before', 'descr', 'before');
opts{end+1}=struct( 'longdescr', 'tensor solver: in operator trunc', 'trunc_mode', 'operator', 'descr', 'operator');
opts{end+1}=struct( 'longdescr', 'dynamic tensor solver', 'dyn', true, 'trunc_mode', 'operator', 'descr', 'dynamic');

ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 row prec tensor solver', ...
    'dyn', true, 'prec', {'ilu', ilu_setup}, 'descr', 'ilutp 2e-2 row'} );

for i=1:length(opts)
    o=opts{i};
    o.type='gpcg';
    o.descr=['gpcg ', o.descr];
    o.longdescr=['gpcg ', o.longdescr];
    opts(end+1)={o};
end
