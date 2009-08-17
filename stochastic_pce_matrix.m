function Delta=stochastic_pce_matrix( k_iota, I_k, I_u )
% STOCHASTIC_PCE_MATRIX Compute the matrix that represents multiplication in the Hermite algebra.
%   DELTA=STOCHASTIC_PCE_MATRIX( K_IOTA, I_K, I_U ) gives the matrix
%   representing multiplication with the random variable K(THETA) with a
%   random variable U(THETA), where K(THETA) is given by its PCE
%   representation K_IOTA with respect to the multiindex set I_K (i.e.
%   K(THETA)=SUM_{IOTA IN I_K} K_IOTA*H_IOTA(THETA)) and U(THETA) as well
%   as the product K*U are represented by a PCE with respect to the
%   multiindex set I_U.
%
% Example (<a href="matlab:run_example stochastic_pce_matrix">run</a>)
%   disp('still to come');
%
% See also

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.



check_condition( {k_iota,I_k}, 'match', false, {'k_iota','I_k'}, mfilename );
check_condition( {I_u,I_k'}, 'match', false, {'I_u','I_k'''}, mfilename );

% initialize hermite_triple function cache
hermite_triple_fast(max([I_k(:); I_u(:)]));

n=size(k_iota,1);
sel=2;
switch sel
    case 1
        m_alpha_u=size(I_u,1);
        Delta=zeros( m_alpha_u, m_alpha_u, n );
        for alpha=1:m_alpha_u
            for beta=alpha:m_alpha_u
                Delta(alpha,beta,:)=k_iota*squeeze(hermite_triple_fast( I_u(alpha,:), I_u(beta,:), I_k ));
                Delta(beta,alpha,:)=Delta(alpha,beta,:);
            end
        end
    case 2
        m_alpha_u=size(I_u,1);
        Delta=zeros( m_alpha_u, m_alpha_u, n );
        for alpha=1:m_alpha_u
            Delta(alpha,:,:)=squeeze(hermite_triple_fast( I_u(alpha,:), I_u, I_k ))*k_iota';
            Delta(:,alpha,:)=Delta(alpha,:,:);
        end
end
