% Elmar Zander, March 2010

mp=multiplot_init( 3, 1 );

%% Preliminary: Load geometry and model data
[pos,els]=create_mesh_1d(0, 1, 1000 );
G_N=mass_matrix( pos, els );

for l_c=[0.02,0.05, 0.2, 0.5, 2]
    cov_func={@gaussian_covariance, {l_c, 1} };
    C=covariance_matrix( pos, cov_func );
    [v,sig]=kl_solve_evp( C, G_N, 100 );

    multiplot( mp, 1, 1 ); plot( pos, funcall(cov_func,pos,[]) );
    
    multiplot( mp, 2, 1 ); plot( sig/sig(1) );
end



