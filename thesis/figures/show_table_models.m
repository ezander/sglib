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
pvar_k=compute_pvar( l_k, var_k, lc_k, cov_k_func, pos_s, G_N_s, area );

var_f=1;
pvar_f=compute_pvar( l_f, var_f, lc_f, cov_f_func, pos_s, G_N_s, area );

% var_k=1;
% cov_k={cov_k_func,{lc_k,sqrt(var_k)}};
% C_k=covariance_matrix( pos_s, cov_k );
% [v_i_k, sigma_k_k]=kl_solve_evp( C_k, G_N_s, l_k );
% pvar_k=roundat( 100*sum(sigma_k_k(1:l_k).^2)/(area*var_k), 0.1 );
% 
% var_f=1;
% cov_f={cov_f_func,{lc_f,sqrt(var_f)}};
% C_f=covariance_matrix( pos_s, cov_f );
% [v_i_k, sigma_f_k]=kl_solve_evp( C_f, G_N_s, l_f );
% pvar_f=roundat( 100*sum(sigma_f_k(1:l_f).^2)/(area*var_f), 0.1 );


c={modelname, l_k, m_k, p_k, pvar_k, l_f, m_f, p_f, pvar_f, p_u, M, N, M*N};
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


function pvar_r=compute_pvar( l_r, var_r, lc_r, cov_r_func, pos, G_N, area )
var_r=1;
cov_r={cov_r_func,{lc_r,sqrt(var_r)}};
C_r=covariance_matrix( pos, cov_r );
[v_i_r, sigma_r_k]=kl_solve_evp( C_r, G_N, l_r );
pvar_r=roundat( 100*sum(sigma_r_k(1:l_r).^2)/(area*var_r), 0.1 );
