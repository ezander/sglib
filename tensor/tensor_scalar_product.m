function d=tensor_scalar_product( T1, T2, G, varargin )
% TENSOR_SCALAR_PRODUCT Compute the scalar product of two tensors.
%   D=TENSOR_SCALAR_PRODUCT( T1, T2 ) computes the scalar product of the
%   two tensors T1 and T2. In the form D=TENSOR_SCALAR_PRODUCT( T1, T2, G )
%   the scalar product is taken with respect to the "mass" matrices or
%   Gramians in G (i.e. G{1} and G{2} for order 2 tensors).
%
% Example (<a href="matlab:run_example tensor_scalar_product">run</a>)
%
% See also TENSOR_NORM

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

if nargin<3
    G={};
end

if isnumeric(T1) && isnumeric(T2)
    if isempty(G)
        d=sum(T1(:).*T2(:));
    elseif isvector(T1)
        d=T1'*G*T2;
    else
        GT2 = tensor_operator_apply_elementary(G, T2);
        d=sum(T1(:).*GT2(:));
    end
elseif is_ctensor(T1) && is_ctensor(T2)
    d=ctensor_scalar_product(T1,T2,G,varargin{:});
elseif isobject(T1) && isobject(T2)
    d=tt_tensor_scalar_product(T1,T2,G);
else
    error( 'sglib:tensor_scalar_product:param_error', ...
        'input parameter is no recognized tensor format or formats don''t match' );
end
