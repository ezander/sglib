function Z=ctensor_null( T )
% CTENSOR_NULL Create a sparse null tensor with correct dimensions.
%   Z=CTENSOR_NULL( T ) create a sparse tensor product with the same
%   dimensions as the tensor T (which is used as kind of a model). In more
%   detail: suppose T consists of an N*K and an M*K matrix then Z will
%   consist of an N*0 and an M*0 matrix.
%
% Example (<a href="matlab:run_example ctensor_null">run</a>)
%   T={rand(8,3), rand(10,3)}
%   Z=ctensor_null(T)
%   norm( Z{1}*Z{2}', 'fro' ) % should be zero
%
% See also CTENSOR_ADD

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

if iscell(T)
    check_tensor_format( T );
    dims=ctensor_size( T );
else
    dims=T;
end

C=zeros(sum(dims),0);
Z=mat2cell(C,dims)';
