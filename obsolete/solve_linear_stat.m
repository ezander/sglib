function [x,flag,relres,iter]=solve_linear_stat( A, b, varargin )
% SOLVE_LINEAR_STAT Solves a linear system using a stationary method.

% NOTE: this implementation is currently very inefficient since there is
% really some matrix decomposition going on here
% TODO: currently we are using here the matrix form expicitly

% TODO: has to be rewritten is large parts, main purpose will be
% comparisons to tensor prod solvers

options=varargin2options( varargin{:} );
[transpose,options]=get_option( options, 'transpose', false );
[method,options]=get_option( options, 'method', 'jacobi' );
[omega,options]=get_option( options, 'overrelax', 1 );
[abstol,options]=get_option( options, 'abstol', 1e-7 );
[reltol,options]=get_option( options, 'reltol', 1e-7 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[algorithm,options]=get_option( options, 'algorithm', 'standard' );
check_unsupported_options( options, mfilename );

switch method
    case {'jacobi', 'jac', 'jor'}
        M=diag(diag(A));
    case {'gauss-seidel', 'gs', 'sor'}
        M=tril(A);
    otherwise
        error( 'solve_jacobi:args', 'Unknown method (%s)', method );
end

switch algorithm
    case {'std', 'standard'}
        [x,flag,relres,iter]=solve_matrix_decomp_std( A, M, b, abstol, reltol, omega, maxiter, transpose );
    case {'generalized', 'gen'}
        matmult=@(x)(A*x);
        vecnorm=@(x)(norm(x));
        scalmult=@(x,a)(a*x);
        vecadd=@(x1,x2)(x1+x2);
        invmatmult=@(x)(M\x);
        if transpose; b=b'; end
        [x,flag,relres,iter]=solve_matrix_decomp_gen( b, abstol, reltol, omega, maxiter, matmult, vecnorm, scalmult, vecadd, invmatmult );
        if transpose; x=x'; end
    case {'tensor'}
        numterms=get_option( options, 'numterms', 5 );
        tensor_alg=get_option( options, 'tensor_alg', 1 );
        matmult={@(x,A)(A*x),A};
        vecnorm=@(x)(norm(x));
        scalmult=@(x,a)(a*x);
        vecadd={@(x1,x2,numterms)(truncated_svd(x1+x2,numterms)),numterms};
        invmatmult={@(x,M)(M\x),M};
        if transpose; b=b'; end
        switch tensor_alg
            case 1
                [x,flag,relres,iter]=solve_matrix_decomp_gen( b, abstol, reltol, omega, maxiter, matmult, vecnorm, scalmult, vecadd, invmatmult );
            case 2
                [x,flag,relres,iter]=solve_matrix_decomp_gen2( b, abstol, reltol, omega, maxiter, matmult, vecnorm, scalmult, vecadd, invmatmult );
        end
        if transpose; x=x'; end
end
switch flag
    case 0
        fprintf( 'solve_mat_decomp converged within %d iterations', iter );
    case 1
        fprintf( 'Maximum iteration count (%d) reached without convergence', maxiter );
end

%%
function [x,flag,relres,iter]=solve_matrix_decomp_gen( b, abstol, reltol, omega, maxiter, matmult, vecnorm, scalmult, vecadd, invmatmult )
flag=0;
x=b;
r=funcall( vecadd, b, funcall( scalmult, funcall(matmult,x),-1));     % r=b-A*x;
init_res=vecnorm(r);

iter=0;
tol=max( funcall( vecnorm,b)*reltol, abstol );

bt=funcall( vecadd, b, funcall( scalmult,b,0) );
tol=max( tol, 2*funcall( vecnorm, funcall( vecadd, b, funcall( scalmult, bt, -1) ) ) );
while vecnorm(r)>tol
    dx=funcall( invmatmult,r);                      % dx=M\r;
    x=funcall( vecadd, x, funcall( scalmult, dx, omega));        % x=x+omega*dx;
    r=funcall( vecadd, b, funcall( scalmult, funcall( matmult, x),-1)); % r=b-A*x;
    iter=iter+1;
    if iter>maxiter
        flag=1;
        break;
    end
end
final_res=norm(r,2);
relres=final_res/init_res;



%%
function [x,flag,relres,iter]=solve_matrix_decomp_gen2( b, abstol, reltol, omega, maxiter, matmult, vecnorm, scalmult, vecadd, invmatmult )
flag=0;
x=b;
r=funcall( vecadd, b, funcall( scalmult, funcall( matmult, x),-1));     % r=b-A*x;
init_res=vecnorm(r);

iter=0;
tol=max( funcall( vecnorm, b)*reltol, abstol );

bt=funcall( vecadd, b, funcall( scalmult, b, 0));

while true
    err=funcall( vecnorm, funcall( vecadd, bt, funcall( scalmult, funcall( matmult, x),-1)) );
    if err<=tol; break; end
%    [err, tol]
    
    dx=funcall( invmatmult, r);                      % dx=M\r;
    x=funcall( vecadd, x, funcall( scalmult, dx, omega));        % x=x+omega*dx;
    r=funcall( vecadd, b, funcall( scalmult, funcall( matmult, x),-1)); % r=b-A*x;
    iter=iter+1;
    if iter>maxiter
        flag=1;
        break;
    end
end
final_res=vecnorm(r);
relres=final_res/init_res;


%%
function [x,flag,relres,iter]=solve_matrix_decomp_std( A, M, b, abstol, reltol, omega, maxiter, transpose )
flag=0;
if transpose
    b=b';
end
x=b;
r=b-A*x;
init_res=norm(r,2);
iter=0;
tol=max( norm(b)*reltol, abstol );

while norm(r)>tol
    dx=M\r;
    x=x+omega*dx;
    r=b-A*x;
    iter=iter+1;
    if iter>maxiter
        flag=1;
        break;
    end
end

if transpose
    x=x';
end
final_res=norm(r,2);
relres=final_res/init_res;
