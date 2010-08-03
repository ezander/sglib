function plot_mesh_and_sample( model, pos, els, f_i_k, f_k_alpha, I_f )
%%
strvarexpand( 'randn seed: $randn(''seed'')$' );
%1919081000
randn('seed',1296810479); %#ok<RAND>
randn('seed',1919081000); %#ok<RAND>
randn('seed',1484588618); %#ok<RAND>

multiplot_init
plot_mesh( pos, els, 'zpos', 1-1, 'bndcolor', 'r' );
axis equal
%plot_field( pos, els, kl_pce_field_realization(k_i_k, k_k_alpha,I_k), 'show_mesh', false );
plot_field( pos, els, kl_pce_field_realization(f_i_k, f_k_alpha,I_f), 'show_mesh', false );
view(3);
save_figure( gca, {'mesh_and_sample_rhs_%s', model}, 'png' );
%plot_kl_pce_mean_var( pos, els, f_i_k, f_k_alpha, I_f, 'show_mesh', false );
