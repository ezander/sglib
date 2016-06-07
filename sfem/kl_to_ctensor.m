function R=kl_to_ctensor( r_i_k, r_k_alpha )
% KL_TO_CTENSOR Pack a KL expansion into tensor product format.
%   R=KL_TO_CTENSOR( R_I_K, R_K_ALPHA ) packs the KL expansion
%   contained in R_I_K and R_K_ALPHA into the tensor product R.
%   R_I_K contains the coefficients of the KL eigenfunctions with respect
%   to the ansatz functions used and R_K_ALPHA contains the PC expansion
%   of the corresponding KL random variable.
%
% See also CTENSOR_TO_KL

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
check_num_args(nargin, 2, 2, mfilename);

if size(r_i_k,2)~=size(r_k_alpha,1)
    error('kl_to_ctensor:size', 'number of kl expansion terms not consistent (transposed?)');
end

% stuff into tensor product (=cell array)
R={ r_i_k, r_k_alpha' };
