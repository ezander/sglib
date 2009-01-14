function [mu_r_j,rho_i_alpha,r_j_i,sqrt_lambda_i]=pce_to_kl( r_j_alpha, I_r, m_r, M_N, M_Phi, varargin );


% PCE_TO_KL Reduce a pure PCE field into a KL-PCE field.

%TODO: overhaul the comments

% ... do an SVD
% directly on the PCE coefficients. If the PCE coefficients are given for
% normalized Hermite polynomials this should give about the same as the
% first method. For unnormalized coefficients we'll certainly get problems.




% In the following we transform from a pure PCE expansion to a KL expansion
% with PCE expanded random variables. I.e. first we have a field u(x,omega)
% given by:
%  u(x,omega)=Sum_alpha u_alpha(x) H_alpha(xi(omega))
% and want to transform it into 
%  u(x,omega)=mu_u(x) + Sum_u f_


options=varargin2options( varargin{:} );
[sparse_svd,options]=get_option( options, 'sparse_svd', false );
[tol,options]=get_option( options, 'tol', 1e-7 );
[maxit,options]=get_option( options, 'maxit', 30 );
check_unsupported_options( options, mfilename );



% Extract the mean of the KL expansion (that's simply the coefficient in
% the PCE corresponding to the multiindex [0,0,0,...] )
mu_r_j=r_j_alpha(:,1);
r_j_alpha(:,1)=0;


% Transform the PCE coefficients from unnormalized (orthogonal) Hermite
% polynomials to normalized (orthonormal) Hermite polynomials
pcc_normed=normalize_pce( r_j_alpha, I_r );

if ~isempty(M_N)
    L_N=chol(M_N);
    pcc_normed=L_N*pcc_normed;
end

[U,S,V]=truncated_svd_internal( pcc_normed, m_r, sparse_svd, tol, maxit );

if ~isempty(M_N)
    U=L_N\U;
end

% error is norm( U*S*V'-pcc )

% Transform PCE coefficients back to unnormalized Hermite polynomials 
rho_i_alpha=normalize_pce( V', I_r, true );

% 
if nargout<4
    r_j_i=U*S;
else
    r_j_i=U;
    sqrt_lambda_i=diag(S);
end




function [U,S,V]=truncated_svd_internal( A, k, sparse_svd, tol, maxit )
if sparse_svd
    options.tol=tol;
    options.maxit=maxit;
    %options.disp=1;
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

