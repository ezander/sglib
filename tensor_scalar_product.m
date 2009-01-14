function d=tensor_scalar_product( T1, T2, M1, M2 )
% TENSOR_SCALAR_PRODUCT Compute the scalar product of two sparse tensors.
%   D=TENSOR_SCALAR_PRODUCT( T1, T2 ) computes the scalar product of the 
%   two sparse tensors T1 and T2. In the form D=TENSOR_SCALAR_PRODUCT( T1,
%   T2, M1, M2 ) the scalar product is taken with respect to the "mass"
%   matrices or Gramians M1 and M2.
%
% Example
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
    M1=[]; M2=[];
end

if isempty(M1)~=isempty(M2)
    error( 'tensor_norm:gramians', 'both gramians must be given or both must be empty' );
end


if 0
    k1=size(T1{1},2);
    k2=size(T2{1},2);
    s=zeros(k1,k2);
    for i=1:k1
        for j=1:k2
            s(i,j)=(T1{1}(:,i)'*T2{1}(:,j))*(T1{2}(:,i)'*T2{2}(:,j));
        end
    end
    d=sum(-1i*sort(1i*s(:)));
end

if ~isempty(M1) 
    s=(T1{1}'*M1*T2{1}).*(T1{2}'*M2*T2{2});
else
    s=(T1{1}'*T2{1}).*(T1{2}'*T2{2});
end
d=sum(-1i*sort(1i*s(:)));
