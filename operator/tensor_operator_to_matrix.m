function A_mat=tensor_operator_to_matrix(A)
% TENSOR_OPERATOR_TO_MATRIX Short description of tensor_operator_to_matrix.
%   TENSOR_OPERATOR_TO_MATRIX Long description of tensor_operator_to_matrix.
%
% Example (<a href="matlab:run_example tensor_operator_to_matrix">run</a>)
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

d=size(A,2);
R=size(A,1);
A_mat=[];
for i=1:R
    B_mat=1;
    for k=1:d
        B_mat=revkron(B_mat,A{i,k});
    end
    if i==1
        A_mat=B_mat;
    else
        A_mat=A_mat+B_mat;
    end
end
