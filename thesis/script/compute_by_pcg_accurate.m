function [U_mat, Ui_mat, info, rho]=compute_by_pcg_accurate( model )

filename=cache_model( model );
load( filename );

modify_system

if prod(tensor_size(Fi))<=3e7
    cache_script( @compute_contractivity );
    reltol=1e-12;
    abstol=1e-12;
    cache_script( @solve_by_gsolve_pcg );
else
    keyboard; % should not get here, or we should need some other treatment of this case
    rho=0.7;
    U_mat=[];
    Ui_mat=[];
    info=[];
end



