%function test_artifical_model6
clear

% This files show how the truncation level affects the final residuum and
% error. This is shown for many truncation levels and the three differenent
% truncation modes. Actually it shows that the truncation mode has no big
% influence at all.

%#ok<*AGROW>

rs=[0.00237, 0.00274, 0.00307, 0.00335, 0.00362, 0.00387 ];
testing=exist('rs$','var');
if testing
    rhos=[];
    for r=rs
        rand('seed', 12345 ); %#ok<RAND>
        randn('seed', 12345 ); %#ok<RAND>
        [A,M,F,X]=setup_test_system( 151, 173, 22, 20, r, 0.6 );
        Minv=stochastic_preconditioner_deterministic( A, true );
        rho=simple_iteration_contractivity( A, Minv );
        rhos(end+1)=rho;
        keyboard
    end
end

for r=rs
    rand('seed', 12345 ); %#ok<RAND>
    randn('seed', 12345 ); %#ok<RAND>
    [A,M,F,X]=setup_test_system( 151, 173, 22, 20, r, 0.6 );
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
    
    model_name=sprintf( 'artmod_small_%03d', round(rho*100) );
    disp( model_name );
    fak=1.0;

    % check that the textbook implementation works
    A_fun=@(x)(tensor_operator_apply(A,x));
    Minv_fun=@(x)(tensor_operator_apply(Minv,x));
    [x,flag,info.relres,info.iter,resvec]=pcg(A_fun,b,1e-12,maxit,Minv_fun);
    t=tic;
    fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
    cmptime=toc(t);
    
    sigma_X=svd(reshape(x,tensor_size(F))); %#ok<NASGU>
    %disp(strvarexpand('sigma_X: $sigma_X(sigma_X>1e-14)$' ));
    %disp(strvarexpand('log(sigma_X): $log10(sigma_X(sigma_X>1e-14))$' ));
    
    analyse_simple_solver
    
end
