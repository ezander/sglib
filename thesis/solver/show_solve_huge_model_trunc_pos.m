function show_solve_huge_model_trunc_pos

clc
%do_compare( 'model_large_easy', get_solve_options )
%do_compare( 'model_large_easy', get_solve_options )
do_compare( 'model_voss_default', get_solve_options )
if false
do_compare( 'model_voss_small_f', get_solve_options )
do_compare( 'model_voss_large_f', get_solve_options )
do_compare( 'model_voss_small_k', get_solve_options )
do_compare( 'model_voss_large_k', get_solve_options )
end
function opts=get_solve_options
opts={};
opts{end+1}=struct( 'longdescr', 'tensor solver: after trunc', 'trunc_mode', 'after', 'descr', 'after');
opts{end+1}=struct( 'longdescr', 'tensor solver: before trunc', 'trunc_mode', 'before', 'descr', 'before');
opts{end+1}=struct( 'longdescr', 'tensor solver: in operator trunc', 'trunc_mode', 'operator', 'descr', 'operator');
opts{end+1}=struct( 'longdescr', 'dynamic tensor solver', 'dyn', true, 'trunc_mode', 'operator', 'descr', 'dynamic');
