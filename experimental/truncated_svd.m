function R_k=truncated_svd( R, k, varargin )

options=varargin2options( varargin{:} );
[sparse_svd,options]=get_option( options, 'sparse_svd', true );
[maxit,options]=get_option( options, 'maxit', 300 ); % same as svds default
[tol,options]=get_option( options, 'tol', 1e-10 ); % same as svds default
check_unsupported_options( options, mfilename );


if iscell(R)
    switch length(R)
        case 2
            A=R{1};
            B=R{2};
            [QA,RA]=qr(A);
            [QB,RB]=qr(B);
            [U,S,V]=truncated_svd_internal(RA*RB',k,sparse_svd,tol,maxit);
            R_k={QA*U*S,QB*V};
        case 3
            s=R{1};
            A=R{2};
            B=R{3};
            [QA,RA]=qr(A*diag(s));
            [QB,RB]=qr(B);
            [U,S,V]=truncated_svd_internal(RA*RB',k,sparse_svd,tol,maxit);
            R_k={diag(S), QA*U, QB*V };
        otherwise
            error( 'strange cell length' );
    end
else
    % This code is only for testing; while working with a full rank matrix
    % we simulate using a rank m approximation; the code above should go
    % directly from a low approximation to a low rank approximation again
    [U,S,V]=truncated_svd_internal(R,k,sparse_svd,tol,maxit);
    R_k=full(U*S*V');
end

function [U,S,V]=truncated_svd_internal( A, k, sparse_svd, tol, maxit )
if sparse_svd
    options.tol=tol;
    options.maxit=maxit;
    [U,S,V,flag]=svds( A, k, 'L', options );
    if flag
        fprintf('warning: svds did not converge to the desired tolerance %g within %d iterations', tol, maxit );
    end
else
    [U,S,V]=svd( A, 'econ' );
    U=U(:,1:k);
    S=S(1:k,1:k);
    V=V(:,1:k);
end

