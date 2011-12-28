function show_input_random_fields
% Show samples of the input random fields kappa and f

cache_script model_large_easy
num_refine=1;
cache_script define_geometry
cache_script discretize_model


mh=multiplot_init( 1, 2 );
set(get(mh(1),'parent'),'renderer','painters')

%rand( 'state' )
randn( 'seed', 12346  )

opts.view=3;
opts.show_mesh=false;

multiplot
%set( mh(i,j), 'Renderer', 'zbuffer' );
ex=kl_pce_field_realization( k_i_k, k_k_alpha, I_k );
zpos=min(ex)-0.2*(max(ex)-min(ex));
plot_field( pos, els, ex, opts );
plot_field_contour( pos, els, ex, 'zpos', zpos, 'color', 'auto' );
plot_boundary(pos,els, 'zpos', zpos, 'color', 'k');
xlabel('x'); ylabel('y');

multiplot
ex=kl_pce_field_realization( f_i_k, f_k_alpha, I_f );
zpos=min(ex)-0.2*(max(ex)-min(ex));
plot_field( pos, els, ex, opts );
plot_field_contour( pos, els, ex, 'zpos', zpos, 'color', 'auto' );
plot_boundary(pos,els, 'zpos', zpos, 'color', 'k');
xlabel('x'); ylabel('y');    

save_figure( mh(1), 'input_field_kappa', 'type', 'raster' );
save_figure( mh(2), 'input_field_f', 'type', 'raster' );
