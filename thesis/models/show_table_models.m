function show_table_models

fprintf('\n\n\n');
underline( 'Model parameters' );
modtable( 'small', 'model_small_easy' )
modtable( 'medium', 'model_medium_easy' )
modtable( 'large', 'model_large_easy' )
modtable( 'huge', 'model_huge_easy' )

function modtable( modelname, modelfile )
eval( modelfile )
eval( 'define_geometry' )
%filename=cache_model( modelfile );
%load( filename );


M=multiindex_size(m_k+m_f,p_u);
nodes=size(pos,2);
bnd=size(bnd_nodes,2);
N=nodes-bnd;

if exist('m_g') && m_g>0 % not handled here, so stop and let user decide
    keyboard
end


area=full(sum(G_N(:)));

var_k=1;
cov_k={cov_k_func,{lc_k,sqrt(var_k)}};
C_k=covariance_matrix( pos_s, cov_k );
[v_i_k, sigma_k_k]=kl_solve_evp( C_k, G_N_s, l_k );
pvar_k=roundat( 100*sum(sigma_k_k(1:l_k).^2)/(area*var_k), 0.1 );

var_f=1;
cov_f={cov_f_func,{lc_f,sqrt(var_f)}};
C_f=covariance_matrix( pos_s, cov_f );
[v_i_k, sigma_f_k]=kl_solve_evp( C_f, G_N_s, l_k );
pvar_f=roundat( 100*sum(sigma_f_k(1:l_f).^2)/(area*var_f), 0.1 );


c={modelname, m_k, l_k, p_k, pvar_k, m_f, l_f, p_f, pvar_f, p_u, M, N, M*N};
tableline( c );

function tableline( c )
for i=1:length(c)
    v=c{i};
    switch class(v)
        case 'char'
            fprintf( '%s', v );
        case 'double'
            if v-round(v)==0
                fprintf( '%d', v );
            else
                fprintf( '%g', v );
            end
    end
    if i==length(c)
        fprintf(' \\\\\n');
    else 
        fprintf(' & ');
    end            
end

