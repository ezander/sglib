function show_field_kappa
%%
%model_large_easy
model_medium
define_geometry
cache_script discretize_model

%%
opts={'dist', dist_k, 'cov', cov_k};
x=[-0.5, 0.4; 0.5, -0.4; 0.9, -0.9; 0.2, 0.5]';

plot_field_complete( pos, els, {k_i_k, k_k_alpha, I_k}, 'N', 1e5, 'x', x, opts{:} )
multiplot( [], 6 ); ylim([0, 10]) 
