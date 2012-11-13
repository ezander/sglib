function A=tensor_operator_extend( A, I, n )
% TENSOR_OPERATOR_EXTEND Short description of tensor_operator_extend.
%   TENSOR_OPERATOR_EXTEND Long description of tensor_operator_extend.
%
% Example (<a href="matlab:run_example tensor_operator_extend">run</a>)
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

check_tensor_operator_format( A );

N=size(A,2);
if nargin<3
    n=N+1;
end

if n<N+1
    A(:,n+1:N+1)=A(:,n:N);
end

A(:,n)=repmat( {I}, size(A,1), 1 );
