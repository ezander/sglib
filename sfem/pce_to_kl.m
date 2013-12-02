function [r_i_k,r_k_alpha,sigma_r_k,relerr]=pce_to_kl( r_i_alpha, I_r, l_r, G_N, G_Phi, varargin )
% PCE_TO_KL Reduce a pure PCE field into a KL-PCE field.
%   [R_I_K,R_K_ALPHA,SIGMA_R_K,RELERR]=PCE_TO_KL( R_I_ALPHA, I_R, L_R,
%   G_N, G_PHI ) computes the KL expansion of the (pointwise) PC expanded
%   random field R, given by R_I_ALPHA, where the random variables in the
%   KL are also given in their corresponding PC expanded form. The
%   multiindex set for the PCE is in I_R; L_R specifies the number of terms
%   in the KL. G_N is the spatial Gramian (AKA mass matrix). G_PHI the
%   stochastic Gramian. In contrast to the normal KL the function R_I_K are
%   not normalized but their 2-norm is equal to SIGMA_K, i.e. the K-th KL
%   eigenvalue.
%
% Example (<a href="matlab:run_example pce_to_kl">run</a>)
%   N=51;
%   [pos,els,bnd]=create_mesh_1d( 0, 1, N );
%   G_N=mass_matrix( pos, els );
%   p_k=4;
%   m_k=4;
%   l_k=12;
%   lc_k=0.3;
%   stdnor_k={@beta_stdnor,{4,2}};
%   cov_k={@gaussian_covariance,{lc_k,1}};
%   [k_i_alpha, I_k]=expand_field_pce_sg( stdnor_k, cov_k, [], pos, G_N, p_k, m_k );
%   [k_i_k,kappa_k_alpha]=pce_to_kl( k_i_alpha, I_k, l_k, G_N );
%
% See also EXPAND_FIELD_PCE_SG

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if ~exist('G_N','var'); G_N=[]; end
if ~exist('G_Phi','var'); G_Phi=[]; end

check_condition( {G_N, r_i_alpha}, 'match', true, {'G_N', 'r_i_alpha'}, mfilename );
check_range( l_r, 0, inf, 'l_r', mfilename );
check_condition( {r_i_alpha, I_r}, 'match', false, {'r_i_alpha', 'I_r'}, mfilename );
check_condition( G_N, 'square', true, 'G_N', mfilename );
check_condition( G_Phi, 'square', true, 'G_Phi', mfilename );


options=varargin2options( varargin );
[sparse_svd,options]=get_option( options, 'sparse_svd', false );
[tol,options]=get_option( options, 'tol', 1e-7 );
[maxiter,options]=get_option( options, 'maxiter', 30 );
check_unsupported_options( options, mfilename );



% Extract the mean of the KL expansion (that's simply the coefficient in
% the PCE corresponding to the multiindex [0,0,0,...] )
mu_r_i=r_i_alpha(:,1);
r_i_alpha(:,1)=0;


% Transform the PCE coefficients from unnormalized (orthogonal) Hermite
% polynomials to normalized (orthonormal) Hermite polynomials
rn_i_alpha=pce_normalize( r_i_alpha, I_r );

if ~isempty(G_N)
    L_N=chol(G_N);
    % this is really strange, but multiplication with a full matrix seems
    % to be many, many times faster (about x15) than with a sparse matrix
    % rn_i_alpha=L_N*rn_i_alpha; % very slow
    % rn_i_alpha=full(L_N)*rn_i_alpha; % fastest, but problematic
    rn_i_alpha=full(L_N*sparse(rn_i_alpha)); %reasonably fast
end

% first l_r if it's out the range
if l_r>min(size(rn_i_alpha))
    l_r=min(size(rn_i_alpha));
end
if sparse_svd && l_r>=min(size(rn_i_alpha))
    sparse_svd=false;
end

[U,S,V,relerr]=truncated_svd_internal( rn_i_alpha, l_r, sparse_svd, tol, maxiter );

if ~isempty(G_N)
    U=L_N\U;
end

% Transform PCE coefficients back to unnormalized Hermite polynomials
r_k_alpha=pce_normalize( V', I_r, true );

% scale spatial KL eigenfunction with KL eigenvalues
r_i_k=U;
sigma_r_k=diag(S);
[r_i_k, r_k_alpha]=kl_pce_to_compact_form(mu_r_i, r_i_k, sigma_r_k, r_k_alpha );


function [U,S,V,relerr]=truncated_svd_internal( A, k, sparse_svd, tol, maxiter )
% TRUNCATED_SVD_INTERNAL Compute the truncated SVD of size k.
if sparse_svd
    options.tol=tol;
    options.maxiter=maxiter;
    options.disp=0;
    [U,S,V,flag]=svds( A, k, 'L', options );
    if flag
        fprintf('warning: svds did not converge to the desired tolerance %g within %d iterations', tol, maxiter );
    end
    relerr=0;
else
    [U,S,V]=svd( A, 'econ' );
    normS=norm(diag(S));
    if normS==0;
        relerr=0;
    else
        relerr=norm(diag(S(k+1:end,k+1:end)))/norm(diag(S));
    end
    U=U(:,1:k);
    S=S(1:k,1:k);
    V=V(:,1:k);
end

