function cmpsol_huge
% show results for solving the huge model

clc
log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_huge_easy', get_solve_options, 'accurate', false )
show_tex_table(1,[]);
log_stop();


function opts=get_solve_options
opts={};
opts{end+1}=struct( 'longdescr', 'normal tensor solver', 'descr', 'normal');
opts{end+1}=struct( 'longdescr', 'dynamic tensor solver', 'dyn', true, 'descr', 'dynamic');

opts{end+1}=varargin2options( {'longdescr', 'prec tensor solver', ...
    'dyn', true, 'prec_strat', {'inside'}, 'descr', 'dyn_inside'} );

ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 row prec tensor solver', ...
    'dyn', true, 'prec_strat', {'ilu', ilu_setup}, 'descr', 'dyn_ilutp'} );



