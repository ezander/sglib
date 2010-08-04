function test_artifical_model5

% What we see here is the development of the 

rand('seed', 12345 ); %#ok<RAND>
randn('seed', 12345 ); %#ok<RAND>

[A,M,F,X]=setup_test_system( 153, 171, 22, 20, 0.002, 0.6 );
F=X;


F=gvector_scale( F, 2/gvector_norm(F) ); % makes reltol more significant than abstol
b=tensor_to_vector(F);
tol=1e-15; maxiter=100;
Minv=stochastic_precond_mean_based( A );

sigma_F=svd(reshape(b,tensor_size(F))); %#ok<NASGU>
disp(strvarexpand('sigma_F: $sigma_F(sigma_F>1e-14)$' ));
disp(strvarexpand('log(sigma_F): $log10(sigma_F(sigma_F>1e-14))$' ));

rho=simple_iteration_contractivity( A, Minv );
disp(rho);


% check that the textbook implementation works
A_fun=@(x)(tensor_operator_apply(A,x));
Minv_fun=@(x)(tensor_operator_apply(Minv,x));
[x,flag,info.relres,info.iter,resvec]=pcg(A_fun,b,1e-12,maxiter,Minv_fun);
fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );

sigma_X=svd(reshape(x,tensor_size(F))); %#ok<NASGU>
disp(strvarexpand('sigma_X: $sigma_X(sigma_X>1e-14)$' ));
disp(strvarexpand('log(sigma_X): $log10(sigma_X(sigma_X>1e-14))$' ));


trunc.eps=1e-18;
trunc.k_max=inf;
trunc.show_reduction=false;

% test with truncation
multiplot_init( 2, 2 );

common={'maxiter', 30, 'reltol', tol, 'abstol', tol, 'Minv', Minv, 'verbosity', 0 };
leg={};
fak=1;
err=[];
k=[];
for km=1:2:30
    trunc.k_max=km;
    leg=[leg {strvarexpand('$km$')}]; %#ok<AGROW>

    [X,flag,info]=generalized_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'operator', 'trunc', trunc   );
    err=[err norm( x-tensor_to_vector( X ) )]
    k=[k km];
end

multiplot;
plot( k, err, 'x-' );

multiplot;
plot( k, log(err), 'x-' );

multiplot;
plot( k, log(err), 'x-' );
plot( log(sigma_X), 'x-' );
err_est_X=kl_estimate_eps( sigma_X, 'full', true, 'N', 100 );
plot( log(err_est_X), 'x-' );

multiplot;
plot( k, log(err), 'x-' );
plot( log(sigma_F), 'x-' );
err_est_F=kl_estimate_eps( sigma_F, 'full', true, 'N', 100 );
plot( log(err_est_F), 'x-' );
