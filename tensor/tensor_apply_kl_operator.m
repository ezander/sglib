function U=tensor_apply_kl_operator( A, T, k, eps, M1, M2, inverse_order )
% TENSOR_APPLY_KL_OPERATOR Apply a KL operator to a sparse tensor product.
%
% Example (<a href="matlab:run_example tensor_apply_kl_operator">run</a>)
%
% See also TENSOR_APPLY

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

if nargin<7 || isempty(inverse_order)
    inverse_order=false;
end

if nargin<6
    M2=[];
end

if nargin<5
    M1=[];
end

if isempty(M1)~=isempty(M2)
    error( 'tensor_truncate:gramians', 'both gramians must be given or both must be empty' );
end


U_det=tensor_apply( {A{1}, A{2}}, T );

if ~inverse_order
    ind=1:length(A{3});
    U=U_det;
else
    ind=length(A{3}):-1:1;
    U=tensor_null( U_det );
end

for i=ind
    dU=tensor_apply( {A{3}{i}, A{4}{i}}, T );
    U=tensor_truncate( tensor_add( U, U_det ), k, eps );
end


if inverse_order
    U=tensor_truncate( tensor_add( U, U_det ), k, eps );
end
