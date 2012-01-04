function test_artifical_model3

rand('seed', 12345 ); %#ok<RAND>
randn('seed', 12345 ); %#ok<RAND>

[A,M,F,X]=setup_test_system( 153, 171, 22, 5, 0.002, 0.4 );
F=X;


F=gvector_scale( F, 2/gvector_norm(F) ); % makes reltol more significant than abstol
b=tensor_to_vector(F);
tol=1e-3; maxiter=100;
Minv=stochastic_precond_mean_based( A );

rho=simple_iteration_contractivity( A, Minv );
disp(rho);


% check that the textbook implementation works
common={'maxiter', 100, 'reltol', tol/100, 'abstol', tol/100, 'Minv', Minv }
[x,flag,info]=generalised_solve_simple( A, b, common{:} );
assert_equals(operator_apply(A,x)-b, zeros(size(b)), 'textbook_res', 'norm', 2, 'abstol', 2*tol );

trunc.k_max=inf;
trunc.show_reduction=false;

% test with truncation
multiplot_init( 2, 2 );

common={'maxiter', 30, 'reltol', tol, 'abstol', tol, 'Minv', Minv, 'verbosity', 1 };
leg={};
fak=1;
for teps=tol*[0.2, 0.1, 0.05, 0.02]
    trunc.eps=teps;
    leg=[leg {strvarexpand('$teps/tol$')}];

    [X,flag,info]=generalised_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'operator', 'trunc', trunc   );
    norm( x-tensor_to_vector( X ) )
    
    multiplot;
    logaxis(gca,'y');
    plot( fak*info.resvec, 'x-' ); 
    legend( leg );
    title( 'residuum' );
    
    multiplot;
    plot( info.rank_res_before, 'x-' ); 
    legend( leg );
    title( 'rank res before prec' );
    
    multiplot;
    plot( info.rank_sol_after, 'x-' ); 
    legend( leg );
    title( 'rank sol after prec' );

    multiplot;
    
end


