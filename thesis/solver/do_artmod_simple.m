global lastr F X A M Minv rho x sigma_X sigma_F cmptime

if isempty(lastr) || lastr~=r
    rand('seed', 12345 ); %#ok<RAND>
    randn('seed', 12345 ); %#ok<RAND>
    [A,M,F,X]=setup_test_system( 151, 173, 22, 20, r, 0.6 );
    F=X;
    
    F=gvector_scale( F, 2/gvector_norm(F) ); % makes reltol more significant than abstol
    b=tensor_to_vector(F);
    Minv=stochastic_preconditioner_deterministic( A, true );
    
    sigma_F=svd(reshape(b,tensor_size(F))); %#ok<NASGU>
    %disp(strvarexpand('sigma_F: $sigma_F(sigma_F>1e-14)$' ));
    %disp(strvarexpand('log(sigma_F): $log10(sigma_F(sigma_F>1e-14))$' ));
    
    rho=simple_iteration_contractivity( A, Minv );
    disp(rho);
    
    % solve by standard pcg
    A_fun=@(x)(tensor_operator_apply(A,x));
    Minv_fun=@(x)(tensor_operator_apply(Minv,x));
    [x,flag,info.relres,info.iter,resvec]=pcg(A_fun,b,1e-12,100,Minv_fun);
    t=tic;
    fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
    cmptime=toc(t);
    
    sigma_X=svd(reshape(x,tensor_size(F))); %#ok<NASGU>
    lastr=r;
else
    disp( 'reusing model' );

end

%analyse_simple_solver

tol=1e-16; % much too small, thus solver goes into stagnation
trunc.eps=eps;
trunc.k_max=inf;
trunc.show_reduction=false;

common={'maxiter', 100, 'reltol', tol, 'abstol', tol, 'Minv', Minv, 'verbosity', 1 };

t=tic;
[X,flag,info]=generalized_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', mode, 'trunc', trunc   );
tt=toc(t);
if exist('x','var') && ~isempty(x)
    curr_err=norm( x-tensor_to_vector( X ) )/gvector_norm(x);
else
    curr_err=1;
end
