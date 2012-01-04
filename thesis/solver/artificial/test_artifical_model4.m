function test_artifical_model4

% What we see here is the development of the rank and the residual for
% different max truncation ranks. residuum (right hand side is chosen to
% have spectrum of 20 eigenvalues going to zero with .6^k. Truncation is
% set to fixed values between 1 and 30. For something like 15 we have a
% border case. For values less no convergence is reached. For higher values
% convergence is as fast as without truncation.

rand('seed', 12345 ); %#ok<RAND>
randn('seed', 12345 ); %#ok<RAND>

[A,M,F,X]=setup_test_system( 153, 171, 22, 20, 0.002, 0.6 );
F=X;


F=gvector_scale( F, 2/gvector_norm(F) ); % makes reltol more significant than abstol
b=tensor_to_vector(F);
tol=1e-3; maxiter=100;
Minv=stochastic_precond_mean_based( A );

sigma_F=svd(reshape(b,tensor_size(F))); %#ok<NASGU>
disp(strvarexpand('sigma_F: $sigma_F(sigma_F>1e-14)$' ));
disp(strvarexpand('log(sigma_F): $log10(sigma_F(sigma_F>1e-14))$' ));

rho=simple_iteration_contractivity( A, Minv );
disp(rho);


% check that the textbook implementation works
common={'maxiter', maxiter, 'reltol', tol/1000, 'abstol', tol/1000, 'Minv', Minv };
[x,flag,info]=generalised_solve_simple( A, b, common{:} );
if flag
    info %#ok<NOPRT>
    keyboard
end
assert_equals(operator_apply(A,x)-b, zeros(size(b)), 'textbook_res', 'norm', 2, 'abstol', 2*tol );

sigma_X=svd(reshape(x,tensor_size(F))); %#ok<NASGU>
disp(strvarexpand('sigma_X: $sigma_X(sigma_X>1e-14)$' ));
disp(strvarexpand('log(sigma_X): $log10(sigma_X(sigma_X>1e-14))$' ));


trunc.eps=1e-13;
trunc.k_max=inf;
trunc.show_reduction=false;

% test with truncation
multiplot_init( 2, 2 );

common={'maxiter', 30, 'reltol', tol, 'abstol', tol, 'Minv', Minv, 'verbosity', 0 };
leg={};
fak=1;
for km=[3 7 10 15 20 25 30]
    trunc.k_max=km;
    leg=[leg {strvarexpand('$km$')}]; %#ok<AGROW>

    [X,flag,info]=generalised_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'operator', 'trunc', trunc   );
    if flag
        info %#ok<NOPRT>
        %keyboard;
    end
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


