%% load or create the geomatry
geom=get_base_param( 'geom', '' );
if isempty(geom)
    N=get_base_param( 'N', 50 );
    [pos,els,bnd_nodes]=create_mesh_1d( 0, 1, N );
    G_N=mass_matrix( pos, els );
    stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};
else
    num_refine=get_base_param( 'num_refine', 1 );
    num_refine_after=get_base_param( 'num_refine_after', 0 );
    show_mesh=get_base_param( 'show_mesh', false );
    if num_refine_after==0
        [pos,els,G_N,ptdata]=load_pdetool_geom( geom, 'numrefine', num_refine, 'showmesh', show_mesh );
        pos_s=pos;
        els_s=els;
        G_N_s=G_N;
        P_s=speye(size(pos_s,2));
    else
        [pos,els,G_N,ptdata]=load_pdetool_geom( geom, 'numrefine', num_refine+num_refine_after, 'showmesh', show_mesh );
        [pos_s,els_s,G_N_s,ptdata_s]=load_pdetool_geom( geom, 'numrefine', num_refine );
        % this could go much much faster
        strvarexpand( 'computing mesh projector: $size(pos_s,2)$=>$size(pos,2)$' );
        P_s=point_projector( pos_s, els_s, pos )';
    end
    bnd_nodes=find_boundary( els, true );
    stiffness_func={@pdetool_stiffness_matrix, {ptdata}, {1}};
end
if ~exist( 'pos_s', 'var' )
    pos_s=pos;
    els_s=els;
    G_N_s=G_N;
    P_s=speye(size(pos_s,2));
end

[d,N]=size(pos);

%
is_neumann=get_base_param( 'is_neumann', make_spatial_func('false') );

all_bnd_nodes=bnd_nodes;
neumann_ind=funcall( is_neumann, pos(:,bnd_nodes) );
neumann_nodes=all_bnd_nodes(neumann_ind);
bnd_nodes=all_bnd_nodes(~neumann_ind);
