function test_artifical_model

rand('seed', 12345 ); %#ok<RAND>
randn('seed', 12345 ); %#ok<RAND>

[A,M,F]=setup( 15, 17, 12, 2, 0.02);

Amat=tensor_operator_to_matrix(A);
Mmat=tensor_operator_to_matrix(M);
F=gvector_scale( F, 2/gvector_norm(F) ); % makes reltol more significant than abstol
b=tensor_to_vector(F);
tol=1e-6; maxit=100; 
Minv=stochastic_preconditioner_deterministic( A, true );
%B=tensor_to_array(F);


% check that the textbook implementation works
x=Amat\b;

common={'maxiter', 30, 'reltol', tol, 'abstol', tol, 'verbosity', 0 };
trunc.k_max=inf;
trunc.show_reduction=false;


% test with truncation
multiplot_init( 2, 2 );
for teps=tol*[0.1, 0.01, 0.001, 0]
    trunc.eps=teps;
    [X1,flag1,info1]=generalized_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'operator', 'trunc', trunc   ); 
    norm( x-tensor_to_vector( X1 ) )
    
    [X2,flag2,info2]=generalized_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'before', 'trunc', trunc   ); 
    norm( x-tensor_to_vector( X2 ) )

    [X3,flag3,info3]=generalized_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'after', 'trunc', trunc   ); 
    norm( x-tensor_to_vector( X3 ) )
    

    multiplot;
    logaxis(gca,'y');
    plot( info1.resvec );
    plot( info2.resvec*1.1 );
    plot( info3.resvec*1.21 );
end


function [A,M,F]=setup( n, m, kA, kf, r )
A{1,1} = matrix_gallery('tridiag',n,-1,2,-1);
A{1,2} = matrix_gallery('randcorr',m);
for i=1:kA
    A{i+1,1}=r*r*matrix_gallery('tridiag',n,-1,3,-1);
    A{i+1,2}=matrix_gallery('randcorr',m);
end
M=A(1,:);
F={rand(n,kf),  rand(m,kf) };


function [x,flag,relres,iter,resvec]=textbook_simple_iter( A, b, tol, maxit, M )
tol=get_base_param('tol', 1e-6, 'caller' );
maxit=get_base_param('maxit', 100, 'caller' );
M=get_base_param('M', speye(size(A)), 'caller' );

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

