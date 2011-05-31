function show_mesh_and_samples

model_large_easy
define_geometry
cache_script discretize_model

use_seed=true;
if use_seed
    %1919081000
    %randn('seed',1296810479); %#ok<RAND>
    %randn('seed',1919081000); %#ok<RAND>
    %randn('seed',1484588618); %#ok<RAND>
    %160614298
    randn('seed',1558575855)
else
    strvarexpand( 'randn seed: $randn(''seed'')$' );
end

multiplot_init
plot_mesh( pos, els, 'zpos', 1-1, 'bndcolor', 'r' );
axis equal
f_ex=kl_pce_field_realization(f_i_k, f_k_alpha,I_f);
f_ex=f_ex-mean(f_ex);
plot_field( pos, els, f_ex, 'show_mesh', false );
view(3);
save_figure( gca, 'mesh_and_sample_rhs', 'type', 'raster' );

