function show_solve_huge_model_trunc_pos

clc
%do_compare( 'model_large_easy', get_solve_options )
do_compare( 'model_large_easy', get_solve_options )

function opts=get_solve_options
opts={};
%opts{end+1}=struct( 'longdescr', 'tensor solver: after trunc', 'trunc_mode', 'after', 'descr', 'after');
% opts{end+1}=struct( 'longdescr', 'tensor solver: before trunc', 'trunc_mode', 'before', 'descr', 'before');
% opts{end+1}=struct( 'longdescr', 'tensor solver: in operator trunc', 'trunc_mode', 'operator', 'descr', 'operator');
opts{end+1}=struct( 'longdescr', 'dynamic tensor solver', 'dyn', true, 'trunc_mode', 'operator', 'descr', 'dynamic');

function foobar_disp_model_data( model )
autoloader( loader_scripts( model ), false, 'caller' );
display_model_details
plot_mesh_and_sample( model, pos, els, f_i_k, f_k_alpha, I_f )
plot_modes( f_i_k,f_k_alpha, pos, cov_f, G_N, F )
