function show_kl_eigenfunc

% %#ok<*NASGU>
 
mh=multiplot_init( 3, 4);
rand('seed', 12345 ); %#ok<RAND>

m=50;
[pos,els,G_N]=load_pdetool_geom( 'lshape', 'numrefine', 1 );

funcs={@gaussian_covariance, @exponential_covariance, @spherical_covariance};
l_c=0.3;
cov_func={funcs{1},{l_c, 1}};

v_f=kl_solve_evp( covariance_matrix( pos, cov_func ), G_N, m );
v_f(:,1)=-v_f(:,1);

for i=1:12
    multiplot( mh, i ); 
    v=v_f(:,i);
    plot_field( pos, els, v, 'show_mesh', true, 'colormap', 'cool', 'view', 3 );
    
    zpos=-1.5;
    plot_boundary( pos, els, 'zpos', zpos );
    plot_field_contour( pos, els, v, 'zpos', zpos );
    
    drawnow;
end

for i=1:12
    save_figure( mh(i), {'kl_eigenfunc_gauss_lshape_%02d', i }, 'type', 'raster' );
end
