contr_maxiter=get_base_param( 'contr_maxiter', 7 );
contr_abstol=get_base_param( 'contr_abstol', 1e-2 );
contr_verbosity=get_base_param( 'contr_verbosity', 1 );

options={'maxiter', contr_maxiter, 'abstol', contr_abstol, 'verbosity', contr_verbosity };

th=tic; 
if verbosity>0; 
    fprintf( 'Contractivity: ' ); 
end

rho=simple_iteration_contractivity( Ki, Mi_inv, options{:} );

if verbosity>0
    toc(th); 
    fprintf( 'Contractivity: rho=%g \n', rho );
end

