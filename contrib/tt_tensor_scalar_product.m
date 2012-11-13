function d=tt_tensor_scalar_product( T1, T2, G )
% TT_TENSOR_SCALAR_PRODUCT Short description of tt_tensor_scalar_product.
%   TT_TENSOR_SCALAR_PRODUCT Long description of tt_tensor_scalar_product.
%
% Example (<a href="matlab:run_example tt_tensor_scalar_product">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

tt_available(true);
if ~isempty(G)
    warning( 'contrib:tensor_toolbox:scalar_product', 'Scalar product with metric not supported' );
end

d=innerprod(T1,T2);
