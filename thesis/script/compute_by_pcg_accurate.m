function [U_mat, Ui_mat, info, rho]=compute_by_pcg_accurate( model )

filename=cache_model( model );
load( filename );

if prod(tensor_size(Fi))<=3e7
    cache_script( @compute_contractivity );
    reltol=1e-12;
    abstol=1e-12;
    cache_script( @solve_by_gsolve_pcg );
else
    rho=0.7;
    U_mat=[];
    Ui_mat=[];
    info=[];
end



