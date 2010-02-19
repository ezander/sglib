function d=tensor_scalar_product( T1, T2, G )
% TENSOR_SCALAR_PRODUCT Compute the scalar product of two sparse tensors.
%   D=TENSOR_SCALAR_PRODUCT( T1, T2 ) computes the scalar product of the
%   two sparse tensors T1 and T2. In the form D=TENSOR_SCALAR_PRODUCT( T1,
%   T2, G ) the scalar product is taken with respect to the "mass"
%   matrices or Gramians in G (i.e. G{1} and G{2} for order 2 tensors).
%
% Example (<a href="matlab:run_example tensor_scalar_product">run</a>)
%
% See also TENSOR_NORM

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

if nargin<3
    G=[];
end

[bool1,format1]=istensor(T1);
[bool2,format2]=istensor(T2);

if ~bool1 || ~bool2
    error( 'tensor:tensor_scalar_product:param_error', ...
        'one input parameter is in no recognized tensor format' );
end
if ~strcmp(format1,format2)
    error( 'tensor:tensor_scalar_product:param_error', ...
        'input parameter have different tensor formats' );
end


if isfull(T1)
    if ~isempty(G)
        error('tensor:tensor_scalar_product:not_implemented', 'not implemented yet' );
    end
    S=T1.*T2;
elseif iscanonical(T1)
    S=ones(tensor_rank(T1),tensor_rank(T2));
    for i=1:length(T1)
        if isempty(G)
            S=S.*inner(T1{i},T2{i},[]);
        else
            S=S.*inner(T1{i},T2{i},G{i});
        end
    end
elseif isobject(T1)
    d=tt_tensor_scalar_product(T1,T2,G);
    return
else
    error( 'tensor:tensor_scalar_product:param_error', ...
        'input parameter is no recognized tensor format' );
end
d=-1i*sum(sort(1i*S(:))); % sum in order of ascending magnitude




function S=inner( A, B, G )
if ~isempty(G)
    S=A'*G*B;
else
    S=A'*B;
end
