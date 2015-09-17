function Z=tensor_null( T )
% TENSOR_NULL Create a null tensor with correct type and dimensions.
%   Z=TENSOR_NULL( T ) creates a tensor Z with the same type and dimensions
%   as the tensor T (which is used as a kind of model). In more detail:
%   suppose T is a canonical tensor and consists of an N*K and an M*K
%   matrix, where K is the rank, then Z will be a canonical tensor
%   consisting of an N*0 and an M*0 matrix. If T is a matrix of size N*M,
%   then Z will be the zero matrix of size N*M.
%
% Example (<a href="matlab:run_example tensor_null">run</a>)
%   T={rand(8,3), rand(10,3)}
%   Z=tensor_null(T)
%   tensor_norm(Z) % should be zero
%
% See also TENSOR_ADD, TENSOR_NORM

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


if isnumeric(T)
    if issparse(T)
        Z=sparse([],[],[],size(T,1),size(T,2),0);
    else
        Z=zeros(size(T));
    end
elseif is_ctensor(T)
    Z=ctensor_null(T);
elseif isobject(T)
    Z=0*T;
else
    error( 'sglib:tensor_null:param_error', ...
        'input parameter is no recognized tensor format' );
end
