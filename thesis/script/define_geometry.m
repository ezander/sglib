%% load or create the geomatry
geom=get_param( 'geom', '' );
if isempty(geom)
    N=get_param( 'N', 50 );
    [pos,els,bnd_nodes]=create_mesh_1d( 0, 1, N );
    G_N=mass_matrix( pos, els );
    stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};
else
    num_refine=get_param( 'num_refine', 1 );
    show_mesh=get_param( 'show_mesh', false );
    [pos,els,G_N,ptdata]=load_pdetool_geom( geom, num_refine, show_mesh );
    bnd_nodes=find_boundary( els, true );
    stiffness_func={@pdetool_stiffness_matrix, {ptdata}, {1}};
end
[d,N]=size(pos);

%
is_neumann=get_param( 'is_neumann', make_spatial_func('false') );

all_bnd_nodes=bnd_nodes;
neumann_ind=funcall( is_neumann, pos(:,bnd_nodes) );
neumann_nodes=all_bnd_nodes(neumann_ind);
bnd_nodes=all_bnd_nodes(~neumann_ind);
