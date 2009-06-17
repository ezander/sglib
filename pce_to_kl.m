function [mu_r_j,rho_i_alpha,r_j_i,relerr,sqrt_lambda_i]=pce_to_kl( r_j_alpha, I_r, m_r, G_N, G_Phi, varargin )
% PCE_TO_KL Reduce a pure PCE field into a KL-PCE field.

%TODO: overhaul the comments
%TODO: really: just use the truncation from tensor_truncate

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
if ~exist('G_N','var'); G_N=[]; end
if ~exist('G_Phi','var'); G_Phi=[]; end

check_condition( {G_N, r_j_alpha}, 'match', true, {'G_N', 'r_j_alpha'}, mfilename );
check_range( m_r, 1, inf, 'm_r', mfilename );
check_condition( {r_j_alpha, I_r}, 'match', false, {'r_j_alpha', 'I_r'}, mfilename );
check_condition( G_N, 'square', true, 'G_N', mfilename );
check_condition( G_Phi, 'square', true, 'G_Phi', mfilename );


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

if ~isempty(G_N)
    L_N=chol(G_N);
    % this is really strange, but multiplication with a full matrix seems
    % to be many, many times faster (about x15) than with a sparse matrix
    % pcc_normed=L_N*pcc_normed; % very slow
    % pcc_normed=full(L_N)*pcc_normed; % fastest, but problematic
    pcc_normed=full(L_N*sparse(pcc_normed)); %reasonably fast
end

[U,S,V,relerr]=truncated_svd_internal( pcc_normed, m_r, sparse_svd, tol, maxit );

if ~isempty(G_N)
    U=L_N\U;
end

% Transform PCE coefficients back to unnormalized Hermite polynomials 
rho_i_alpha=normalize_pce( V', I_r, true );

if nargout<5
    r_j_i=U*S;
else
    r_j_i=U;
    sqrt_lambda_i=diag(S);
end




function [U,S,V,relerr]=truncated_svd_internal( A, k, sparse_svd, tol, maxit )
% TRUNCATED_SVD_INTERNAL Compute the truncated SVD of size k.
if sparse_svd
    options.tol=tol;
    options.maxit=maxit;
    options.disp=0;
    [U,S,V,flag]=svds( A, k, 'L', options );
    if flag
        fprintf('warning: svds did not converge to the desired tolerance %g within %d iterations', tol, maxit );
    end
    relerr=0;
else
    [U,S,V]=svd( A, 'econ' );
    relerr=norm(diag(S(k+1:end,k+1:end)))/norm(diag(S));
    U=U(:,1:k);
    S=S(1:k,1:k);
    V=V(:,1:k);
end

