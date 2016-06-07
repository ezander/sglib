function [r_i_k, r_k_alpha]=ctensor_to_kl( R, normalize )
% CTENSOR_TO_KL Unpack a KL expansion from a tensor product.
%   [R_I_K, R_K_ALPHA]=CTENSOR_TO_KL( R ) unpacks a KL expansion
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
% See also KL_TO_CTENSOR

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% check input arguments
check_num_args(nargin, 1, 2, mfilename);

if nargin<2
    normalize=true;
end

% extract parts from the tensor (second component is transposed in KL form)
r_i_k=R{1};
r_k_alpha=R{2}';


if normalize
    [mu_rs_i, rs_i_k, sigma_rs_k, rs_k_alpha]=kl_pce_to_standard_form(r_i_k, r_k_alpha);
    [r_i_k, r_k_alpha]=kl_pce_to_compact_form( mu_rs_i, rs_i_k, sigma_rs_k, rs_k_alpha );
end
