function show_model_bcs_and_solution
% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

if fasttest('get')
    model_medium_easy
else
    model_large_easy
end

m_f=min(m_f,10);
num_refine_after=0;
define_geometry
cache_script discretize_model
cache_script setup_equation
cache_script solve_by_standard_pcg
solution_vec2mat



mh=multiplot_init(2,3);
opts={'view', 3};
[u_mean,u_var]=pce_moments( U_mat, I_u );

multiplot(mh,1); plot_field(pos, els, u_mean, opts{:}, 'show_mesh', true ); 
multiplot(mh,2); plot_field(pos, els, sqrt(u_var), opts{:} ); 

multiplot(mh,3); 
plot_boundary_conds( pos, els, 'zpos', g_i_k(:,1)', 'neumann_nodes', neumann_nodes, 'bndwidth', 2 )
axis tight


[k_mean,k_var]=kl_pce_moments( k_i_k, k_k_alpha, I_k );
%[k_mean,k_var]=kl_pce_moments( f_i_k, f_k_alpha, I_f );
multiplot(mh,4); hold off; plot_field(pos, els, k_mean, opts{:}, 'show_mesh', true ); 
multiplot(mh,5); hold off; plot_field(pos, els, sqrt(k_var), opts{:} ); 


%%
save_figure( mh(1), 'solution_mean', 'type', 'raster' );
save_figure( mh(2), 'solution_stddev', 'type', 'raster' );
save_figure( mh(3), 'boundary_conds', 'type', 'raster' );


