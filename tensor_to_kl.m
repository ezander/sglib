function [r_i_k, r_k_alpha]=tensor_to_kl( R )
% TENSOR_TO_KL Unpack a KL expansion from a tensor product.
%   [R_I_K, R_K_ALPHA]=TENSOR_TO_KL( R ) unpacks a KL expansion
%   from the tensor product R into R_I_K and R_K_ALPHA. R_I_K
%   contains the coefficients of the KL eigenfunctions with respect to the
%   ansatz functions used, and R_K_ALPHA contains the PC expansion of the
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
r_i_k=R{1};
r_k_alpha=R{2}';
