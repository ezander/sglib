function Z=gvector_null( T )
% GVECTOR_NULL Create a sparse null vector with correct dimensions.
%   Z=GVECTOR_NULL( T ) create a sparse vector product with the same
%   dimensions as the vector T (which is used as kind of a model). In more
%   detail: suppose T consists of an N*K and an M*K matrix then Z will
%   consist of an N*0 and an M*0 matrix.
%
% Example (<a href="matlab:run_example gvector_null">run</a>)
%   T={rand(8,3), rand(10,3)}
%   Z=gvector_null(T)
%   norm( Z{1}*Z{2}', 'fro' ) % should be zero
%
% See also GVECTOR_ADD

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


if isnumeric(T)
    Z=zeros(size(T));
elseif iscell(T)
    Z=tensor_null(T);
elseif isobject(T)
    Z=0*T;
else
    error( 'vector:gvector_null:param_error', ...
        'input parameter is no recognized vector format' );
end
