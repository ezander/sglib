function [mu_r_j, r_j_i, rho_i_alpha]=tensor_to_kl( R )
% TENSOR_TO_KL Unpack a KL expansion from a tensor product.
%   [MU_R_J, R_J_I, RHO_I_ALPHA]=TENSOR_TO_KL( R ) unpacks a KL expansion
%   from the tensor product R into MU_R_J, R_J_I and RHO_I_ALPHA. MU_R_J
%   contains the mean of the random field or stochastic process, R_J_I
%   contains the coefficients of the KL eigenfunctions with respect to the
%   ansatz functions used, and RHO_I_ALPHA contains the PC expansion of the
%   corresponding KL random variable.
%
%   Note: This function does not guarantee orthogonality of eigenfunctions
%   or uncorrelatedness of random variables like the KL. It just unpacks
%   the information contained in R into the format used by the KL. However,
%   if the tensor was truncated in a "KL-compatible" way, the result should
%   be the same.
%
% See also KL_TO_TENSOR

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% check input arguments
error( nargchk( 1, 1, nargin ) );

% extract parts from the tensor (second component is transposed in KL form)
r_j_i=R{1};
rho_i_alpha=R{2}';

% now extract deterministic part and clear that one from the variable part
mu_r_j=r_j_i*rho_i_alpha(:,1);
rho_i_alpha(:,1)=0;

% if we have a full zero for a random variable we can erase that (this
% sometimes happens when first combining a KL to a tensor and then doing
% the reverse process)
if all(rho_i_alpha(1,:)==0)
    rho_i_alpha=rho_i_alpha(2:end,:);
    r_j_i=r_j_i(:,2:end);
end
