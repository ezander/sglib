function [U_mat, Ui_mat, info, rho]=compute_by_pcg_accurate( model, solve_opts, mod_opts )

filename=cache_model( model );
load( filename );

modify_system

if prod(tensor_size(Fi))<=3e7
    cache_script( @compute_contractivity );
    reltol=1e-12;
    abstol=1e-12;
    solver_name='gpcg'; 
    vector_type='matrix';
    cache_script( @solve_by_gsolve );
else
    keyboard; % should not get here, or we should need some other treatment of this case
end



