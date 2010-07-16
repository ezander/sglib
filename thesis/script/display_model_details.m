%%
underline( 'Random fields' );
strvarexpand( 'dist_k: $dist_k$  cov_k: $disp_func( cov_k )$' )
strvarexpand( 'm_k: $m_k$, p_k: $p_k$, l_k: $l_k$ M_k: $multiindex_size( m_k, p_k )$' );
strvarexpand(' ')
strvarexpand( 'dist_f: $dist_f$  cov_f: $disp_func( cov_f )$' )
strvarexpand( 'm_f: $m_f$, p_f: $p_f$, l_f: $l_f$ M_f: $multiindex_size( m_f, p_f )$' );
strvarexpand(' ')
strvarexpand( 'dist_g: $dist_g$  cov_g: $disp_func( cov_g )$' )
strvarexpand( 'm_g: $m_g$, p_g: $p_g$, l_g: $l_g$ M_g: $multiindex_size( m_g, p_g )$' );
strvarexpand(' ')

m_u=m_f+m_g+m_k+m_h; l_u=nan;
strvarexpand( 'm_u: $m_u$, p_u: $p_u$, l_u: $l_u$ M_u: $multiindex_size( m_u, p_u )$' );
strvarexpand(' ')

nodes=size(pos,2);
bnd=size(bnd_nodes,2);
inner=nodes-bnd;
M_u=multiindex_size( m_u, p_u );
underline( 'Geometry and system size' );
strvarexpand( 'name: $geom$ nodes: $nodes$ inner: $inner$ bnd: $bnd$' );
strvarexpand(' ')

strvarexpand( 'full-size: $nodes$x$M_u$=$nodes*M_u$' );
strvarexpand( 'inner-size: $inner$x$M_u$=$inner*M_u$' );
strvarexpand(' ')

if isunix
    underline( 'System' );
    fprintf( 'cpu: ' ); system( 'cat /proc/cpuinfo | grep "model name" | head -n1' );
    fprintf( 'mem: ' ); system( 'cat /proc/meminfo | grep "MemTotal" ' );
end

%%
%profile on
%randn('seed',100)
randn('seed')
randn('seed',1173063571)
multiplot_init
plot_mesh( pos, els, 'zpos', -1, 'bndcolor', 'r' );
axis equal
%plot_field( pos, els, kl_pce_field_realization(k_i_k, k_k_alpha,I_k), 'show_mesh', false );
plot_field( pos, els, kl_pce_field_realization(f_i_k, f_k_alpha,I_f), 'show_mesh', false );
view(3);

%plot_kl_pce_mean_var( pos, els, f_i_k, f_k_alpha, I_f, 'show_mesh', false );


