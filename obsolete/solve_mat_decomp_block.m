function [x,flag,relres,iter]=solve_mat_decomp_block( A, b, varargin )
% SOLVE_MAT_DECOMP Solves a linear system using a matrix deomposition method.

% NOTE: this implementation is currently very inefficient since there is
% really some matrix decomposition going on here
% TODO: currently we are using here the matrix form expicitly

%% init section
options=varargin2options( varargin{:} );
[method_str,options]=get_option( options, 'method', 'jacobi' );
[omega,options]=get_option( options, 'overrelax', 1 ); %#ok
[abstol,options]=get_option( options, 'abstol', 1e-7 );
[reltol,options]=get_option( options, 'reltol', 1e-7 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[algorithm,options]=get_option( options, 'algorithm', 'standard' ); %#ok
check_unsupported_options( options, mfilename );


switch method_str
    case {'jacobi', 'jac', 'jor'}
        method=1;
    case {'gauss-seidel', 'gs', 'sor'}
        method=2;
    otherwise
        error( 'solve_jacobi:args', 'Unknown method (%s)', method_str );
end

%% solver section

if method; 1; end
K_ab=A;
flag=0;
x=0*b;
r=b - apply_stochastic_operator( K_ab, x ); % r=b-A*x;
init_res=vecnorm(r);

iter=0;
tol=max( init_res*reltol, abstol );

fprintf( 'Iter: %d\n', iter+1 );
while vecnorm(r)>tol
    n=size(K_ab,1);
    for i=1:n
        %fprintf( 'i: %d/%d\n', i, n );
        if 0
            % C/C++ style
            r_i=b(:,i);
            for j=1:n
                if j~=i; r_i=r_i-K_ab{i,j}*x(:,j); end
            end
        else
            % matlab-style
            ind=1:n; ind(i)=[];
            r_i=b(:,i)-cell2mat(K_ab(i,ind))*reshape(x(:,ind),[],1);
        end
        x(:,i)=K_ab{i,i}\r_i;
    end
    svd_options.sparse_svd=false;
    x=truncated_svd( x, 10, svd_options );
    % dx=M\r;
    % x=x+omega*dx;
    r=b - apply_stochastic_operator( K_ab, x ); % r=b-A*x;
    fprintf( 'Iter: %d -> %g\n', iter, vecnorm(r)/tol );

    iter=iter+1;
    if iter>maxiter
        flag=1;
        break;
    end
end
final_res=norm(r,2);
relres=final_res/init_res;


%%
function n=vecnorm( x )
% out vectors are matrices so we'll use the frobenius norm for them
% This corresponds to the normal 2-norm on the vector, but is it really the
% best? The truncated svd gives us a best approximation with respect to the
% 2-norm, but this is relatively expensive to compute...
n=norm(x,'fro');
