function test_artifical_model6

% This files show how the truncation level affects the final residuum and
% error. This is shown for many truncation levels and the three differenent
% truncation modes. Actually it shows that the truncation mode has no big
% influence at all.

rand('seed', 12345 ); %#ok<RAND>
randn('seed', 12345 ); %#ok<RAND>

[A,M,F,X]=setup_test_system( 153, 171, 22, 20, 0.002, 0.6 );
F=X;


F=gvector_scale( F, 2/gvector_norm(F) ); % makes reltol more significant than abstol
b=tensor_to_vector(F);
tol=1e-15; maxit=100;
Minv=stochastic_preconditioner_deterministic( A, true );

sigma_F=svd(reshape(b,tensor_size(F))); %#ok<NASGU>
disp(strvarexpand('sigma_F: $sigma_F(sigma_F>1e-14)$' ));
disp(strvarexpand('log(sigma_F): $log10(sigma_F(sigma_F>1e-14))$' ));

rho=simple_iteration_contractivity( A, Minv );
disp(rho);


% check that the textbook implementation works
A_fun=@(x)(tensor_operator_apply(A,x));
Minv_fun=@(x)(tensor_operator_apply(Minv,x));
[x,flag,info.relres,info.iter,resvec]=pcg(A_fun,b,1e-12,maxit,Minv_fun);
fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );

sigma_X=svd(reshape(x,tensor_size(F))); %#ok<NASGU>
disp(strvarexpand('sigma_X: $sigma_X(sigma_X>1e-14)$' ));
disp(strvarexpand('log(sigma_X): $log10(sigma_X(sigma_X>1e-14))$' ));


trunc.eps=1e-18;
trunc.k_max=inf;
trunc.show_reduction=false;

% test with truncation
multiplot_init( 3, 2 );

for xxx=1:3
    modes={'operator', 'before', 'after'};
    mode=modes{xxx};
    
    common={'maxiter', 30, 'reltol', tol, 'abstol', tol, 'Minv', Minv, 'verbosity', 0 };
    leg={};
    fak=1;
    err=[];
    res=[];
    ep=[];
    multiplot([],1);
    logaxis( gca, 'y' );
    for eps=10.^-[0:0.5:10]
        trunc.eps=eps;
        leg=[leg {strvarexpand('$eps$')}]; %#ok<AGROW>
        
        %[X,flag,info]=generalized_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'operator', 'trunc', trunc   );
        [X,flag,info]=generalized_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', mode, 'trunc', trunc   );
        err=[err norm( x-tensor_to_vector( X ) )/gvector_norm(x)]
        res=[res info.relres/gvector_norm(F)];
        ep=[ep eps];
        plot( info.resvec );
        %legend( leg );
    end
    
    multiplot([],2);
    logaxis( gca, 'xy' );
    plot( ep, err, 'x-' );
    legend_add( mode );
    
    multiplot([],3);
    logaxis( gca, 'xy' );
    plot( ep, res, 'x-' );
    legend_add( mode );
    
    multiplot([],4);
    logaxis( gca, 'x' );
    plot( ep, err./ep, 'x-' );
    legend_add( mode );
    
    multiplot([],5);
    logaxis( gca, 'x' );
    plot( ep, res./ep, 'x-' );
    legend_add( mode );
    
end

multiplot([],2);
plot( ep, ep, '-' );
legend_add( '"identity"' );

multiplot([],3);
plot( ep, ep, '-' );
legend_add( '"identity"' );


keyboard
