function test_artifical_model

rand('seed', 12345 ); %#ok<RAND>
randn('seed', 12345 ); %#ok<RAND>

[A,M,F]=setup( 153, 171, 22, 2, 0.002);

Amat=tensor_operator_to_matrix(A);
Mmat=tensor_operator_to_matrix(M);
F=gvector_scale( F, 2/gvector_norm(F) ); % makes reltol more significant than abstol
b=tensor_to_vector(F);
tol=1e-3; maxit=100; 
Minv=stochastic_preconditioner_deterministic( A, true );
%B=tensor_to_array(F);

rho=simple_iteration_contractivity( A, operator_from_matrix(Mmat,true,'use_lu', true) );
disp(rho);



% check that the textbook implementation works
[x,flag,relres,iter,resvec]=textbook_simple_iter( Amat, b, tol, maxit, Mmat ); %#ok<ASGLU>
assert_equals(x,Amat\b,'textbook', 'abstol', 1e-4);
assert_equals(Amat*x-b, zeros(size(b)), 'textbook_res', 'norm', 2, 'abstol', 2*tol );

x=Amat\b;

trunc.k_max=inf;
trunc.show_reduction=false;


% test with truncation
multiplot_init( 2, 2 );
    multiplot;
    
%for teps=tol*[0.1, 0.01, 0.001, 0.0001]
%for teps=tol*[0.1, 0.05, 0.02, 0.01]
for teps=tol*[0.1, 0.08, 0.06, 0.04]
    trunc.eps=teps;
    trunc_func={@tensor_truncate_fixed, {trunc}, {2} };
%     [X1,flag1,info1]=generalized_solve_simple( A, F, 'reltol', tol, 'abstol', tol, 'Minv', Minv, 'truncate_before_func', trunc_func ); %#ok<ASGLU>
%     norm( x-tensor_to_vector( X1 ) )
%     
%     [X2,flag2,info2]=generalized_solve_simple( A, F, 'reltol', tol, 'abstol', tol, 'Minv', Minv, 'truncate_after_func', trunc_func ); %#ok<ASGLU>
%     norm( x-tensor_to_vector( X2 ) )
    
    [X3,flag3,info3]=generalized_solve_simple( A, F, 'reltol', tol, 'abstol', tol, 'Minv', Minv, 'truncate_operator_func', trunc_func ); %#ok<ASGLU>
    norm( x-tensor_to_vector( X3 ) )

    logaxis(gca,'y');
%     plot( info1.resvec );
%     plot( info2.resvec*1.1 );
    plot( info3.resvec ); drawnow;
end
plot( info3.resvec(1)*rho.^(0:length(resvec)) );
legend( '0.1', '0.01', '0.001', '0.0001', 'rho' );

function [A,M,F]=setup( n, m, kA, kf, r )
mask=sparse(m,m);
for i=1:m; mask( i, max(i-2,1):min(i+2,m) )=1; end
    
A{1,1} = matrix_gallery('tridiag',n,-1,2,-1);
A{1,2} = matrix_gallery('randcorr',m);
A{1,2} = sparse(diag(diag(A{1,2})));
for i=1:kA
    A{i+1,1}=r*r*matrix_gallery('tridiag',n,-1,3,-1);
    A{i+1,2}=matrix_gallery('randcorr',m);
    
    A{i+1,2} = mask.*A{i+1,2};
end
M=A(1,:);
F={rand(n,kf),  rand(m,kf) };


function [x,flag,relres,iter,resvec]=textbook_simple_iter( A, b, tol, maxit, M )
tol=get_param_default('tol', 1e-6 );
maxit=get_param_default('maxit', 100 );
M=get_param_default('M', speye(size(A)) );

x=zeros(size(b));
r=b;
norm_r0=norm(b);
resvec=[norm_r0];

flag=1;
tolb=tol*norm_r0;
for iter=1:maxit
    x=x+M\r;
    r=b-A*x;
    
    resvec(end+1)=norm(r); %#ok<AGROW>
    if norm(r)<tolb
        flag=1;
        break;
    end
end
relres=norm(r)/norm_r0;
resvec=resvec(:);

function value=get_param_default( name, default )
try
    value=evalin( 'caller', name );
catch
    value=default;
end

