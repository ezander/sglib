function R=kl_to_tensor( mu_r_j, r_j_i, rho_i_alpha )
% KL_TO_TENSOR Pack a KL expansion into tensor product format.
%   R=KL_TO_TENSOR( MU_R_J, R_J_I, RHO_I_ALPHA ) packs the KL expansion
%   contained in MU_R_J, R_J_I and RHO_I_ALPHA into the tensor product R.
%   MU_R_J contains the mean of the random field or stochastic process,
%   R_J_I contains the coefficients of the KL eigenfunctions with respect
%   to the ansatz functions used, and RHO_I_ALPHA contains the PC expansion
%   of the corresponding KL random variable.
%
% See also TENSOR_TO_KL

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
error( nargchk( 3, 3, nargin ) );

if size(mu_r_j,1)~=size(r_j_i,1)
    error('kl_to_tensor:size', 'spatial dimension not consistent (transposed?)');
end
if size(r_j_i,2)~=size(rho_i_alpha,1)
    error('kl_to_tensor:size', 'number of kl expansion terms not consistent (transposed?)');
end

% make PCE vector for the mean component (1,0,0,0,...)
rho_0_alpha=[1, zeros(1,size(rho_i_alpha,2)-1)];
% stuff into tensor product (=cell array)
R={[mu_r_j, r_j_i], [rho_0_alpha; rho_i_alpha]'};
