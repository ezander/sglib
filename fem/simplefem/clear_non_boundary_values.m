function g_i_k=clear_non_boundary_values( g_i_k, bnd_nodes )

ind=true(size(g_i_k,1),1);
ind(bnd_nodes)=false;
g_i_k(ind,:)=0;
