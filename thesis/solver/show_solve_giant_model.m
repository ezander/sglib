function show_solve_giant_model

clc
%do_compare( 'model_large_easy', get_solve_options )
do_compare( 'model_giant_easy', get_solve_options )

function opts=get_solve_options
opts={};
opts{end+1}=struct( 'longdescr', 'normal tensor solver', 'descr', 'normal');
opts{end+1}=struct( 'longdescr', 'dynamic tensor solver', 'dyn', true, 'descr', 'dynamic');
