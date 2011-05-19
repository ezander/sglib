function x

modtable( 'small', 'model_small_easy' )
%modtable( 'medium', 'model_medium_easy' )
%modtable( 'large', 'model_large_easy' )
%modtable( 'huge', 'model_huge_easy' )

function modtable( modelname, modelfile )
eval( modelfile )
eval( 'define_geometry' )
M=multiindex_size(m_k+m_f,p_u);
nodes=size(pos,2);
bnd=size(bnd_nodes,2);
N=nodes-bnd;

if exist('m_g') && m_g>0 % not handled here, so stop and let user decide
    keyboard
end


cov_k={cov_k_func,{lc_k,1}};
C_k=covariance_matrix( pos_s, cov_k );
[v_i_k, sigma_k_k]=kl_solve_evp( C_k, G_N_s, min( [size(C_k,1)-1, 200]) );
var_k=roundat( 100*sum(sigma_k_k(1:l_k))/sum(sigma_k_k), 0.1 )

cov_f={cov_f_func,{lc_f,1}};
C_f=covariance_matrix( pos_s, cov_f );
G_N_s=speye(size(G_N_s));
[v_i_k, sigma_f_k]=kl_solve_evp( C_f, G_N_s, min( [size(C_f,1)-1, 200] ) );
var_f=roundat( 100*sum(sigma_f_k(1:l_f))/sum(sigma_f_k), 0.1 );



c={modelname, m_k, l_k, p_k, var_k, m_f, l_f, p_f, var_f, p_u, M, N, M*N};
tableline( c );

function tableline( c )
for i=1:length(c)
    v=c{i};
    switch class(v)
        case 'char'
            fprintf( '%s', v );
        case 'double'
            fprintf( '%g', v );
    end
    if i==length(c)
        fprintf(' \\\\\n');
    else 
        fprintf(' & ');
    end            
end

