function Delta_i=compute_pce_matrix( k_i_iota, I_k, I_u, varargin )
% COMPUTE_PCE_MATRIX Compute the matrix that represents multiplication in the Hermite algebra.
%   DELTA_I=COMPUTE_PCE_MATRIX( K_I_IOTA, I_K, I_U ) computes the matrices
%   DELTA_I representing multiplication with the random variables
%   K_I(THETA) by a random variable U(THETA), where K_I(THETA) is given by
%   its PCE representation K_I_IOTA with respect to the multiindex set I_K
%   (i.e. K(THETA)=SUM_{IOTA IN I_K} K_I_IOTA*H_IOTA(THETA)) and U(THETA)
%   as well as the product K*U are represented by a PCE with respect to the
%   multiindex set I_U. Of U only the multiindex set is needed.
%
% Example (<a href="matlab:run_example compute_pce_matrix">run</a>)
%    I_u=multiindex(3,2);
%    I_k=multiindex(3,3);
%    k_i_iota=rand(2,size(I_k,1));
%    Delta_i=compute_pce_matrix( k_i_iota, I_k, I_u )
%
% See also COMPUTE_PCE_RHS, COMPUTE_PCE_OPERATOR, KL_PCE_COMPUTE_OPERATOR

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

check_condition( {k_i_iota,I_k}, 'match', false, {'k_i_iota','I_k'}, mfilename );
check_condition( {I_u,I_k'}, 'match', false, {'I_u','I_k'''}, mfilename );

options=varargin2options( varargin );
[algorithm,options]=get_option( options, 'algorithm', 3 );
check_unsupported_options( options, mfilename );

% initialize hermite_triple function cache
%hermite_triple_fast(max([I_k(:); I_u(:)]));

n=size(k_i_iota,1);
% We have different versions for computing the pce matrix here, with
% different levels of vectorization. The old versions (1 and 2) are left in
% to have comparisons when optimizations are performed.
switch algorithm
    case 1
        m_alpha_u=size(I_u,1);
        Delta_i=zeros( m_alpha_u, m_alpha_u, n );
        for alpha=1:m_alpha_u
            for beta=alpha:m_alpha_u
                Delta_i(alpha,beta,:)=k_i_iota*squeeze(hermite_triple_fast( I_u(alpha,:), I_u(beta,:), I_k ));
                Delta_i(beta,alpha,:)=Delta_i(alpha,beta,:);
            end
        end
    case 2
        m_alpha_u=size(I_u,1);
        Delta_i=zeros( m_alpha_u, m_alpha_u, n );
        for alpha=1:m_alpha_u
            Delta_i(alpha,:,:)=squeeze(hermite_triple_fast( I_u(alpha,:), I_u, I_k ))*k_i_iota';
            Delta_i(:,alpha,:)=Delta_i(alpha,:,:);
        end
    case 3
        M=hermite_triple_fast( I_u, I_u, I_k );
        Delta_i=tensor_multiply( M, k_i_iota, 3, 2 );
    case 4
        M=hermite_triple_fast( I_u, I_u, I_k, 'algorithm', 'sparseb' );
        Delta_i=M*sparse(k_i_iota');
end
