% solving only the deterministic case (for a. litvinenko)

[pos,els,G_N,ptdata]=load_pdetool_geom( 'lshape', 'numrefine', 1 );
stiffness_func={@pdetool_stiffness_matrix, {ptdata}, {1}};
bnd_nodes=find_boundary( els, true );
[P_I,P_B]=boundary_projectors( bnd_nodes, size(pos,2) );
opts={'view', 3};

mh=multiplot_init(2,2);

k=spatial_function( '1+x', pos );
multiplot; plot_field( pos, els, k, opts{:} ); title( 'k' );

f=spatial_function( 'sin(2*pi*x)', pos );
%f=spatial_function( '0', pos );
multiplot; plot_field( pos, els, f, opts{:} ); title( 'f' );

g=spatial_function( 'sin(pi*x)+y^2', pos );
multiplot; plot_field( pos, els, g, opts{:} ); title( 'g' );

K=funcall( stiffness_func, k );
Ki=apply_boundary_conditions_operator( K, P_I );
fi=apply_boundary_conditions_rhs( K, f, g, P_I, P_B );
ui=Ki\fi;
u=apply_boundary_conditions_solution( ui, g, P_I, P_B );
multiplot; plot_field(pos, els, u, opts{:} ); title( 'u' );

same_scaling( mh, 'zc' );


