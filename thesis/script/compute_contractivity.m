maxiter=get_base_param( 'maxiter', 7 );
abstol=get_base_param( 'abstol', 1e-2 );
verbosity=get_base_param( 'verbosity', 1 );

options={'maxiter', maxiter, 'abstol', abstol, 'verbosity', verbosity };

th=tic; 
if verbosity>0; 
    fprintf( 'Contractivity: ' ); 
end

rho=simple_iteration_contractivity( Ki, Mi_inv, options{:} );

if verbosity>0
    toc(th); 
    fprintf( 'Contractivity: rho=%g \n', rho );
end

