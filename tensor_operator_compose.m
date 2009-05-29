function A=tensor_operator_compose( A2, A1 )
% TENSOR_OPERATOR_COMPOSE Return the composition of two tensor operators.
%   A=TENSOR_OPERATOR_COMPOSE( A2, A1 ) returns the composition A of the
%   tensor operators A1 and A2 such that A(X)=A2(A1(X))). If one of the
%   operators is purely numeric (i.e. a matrix), then the result will also
%   be a matrix, i.e. the other operator, if not already a matrix, will be
%   taken as its transposed Kronecker product. 
%  
%   Note: You can use this also to convert a tensor operator from tensor
%   format to matrix format by composing it with the identity matrix.
%
% Example (<a href="matlab:run_example tensor_operator_compose">run</a>)
%    A1={ [1 2; 3 4], [3 5 1; 6 4 2; 2 3 7 ] };
%    A2={ [1 1; 2 2], [1 1 1; 2 2 2; 3 3 3 ] };
%    A1M=tkron( A1 );
%    A2M=tkron( A2 );
%    x={[1;2], [6;3;2]}; xv=tkron(x);
%    % in tensor format
%    A=tensor_operator_compose( A1, A2 )
%    y1=tensor_operator_apply( A, x );
%    y2=tensor_operator_apply( A2, tensor_operator_apply( A1, x ) );
%    % in Kronecker product/matrix format
%    AM=tensor_operator_compose( A1M, A2 )
%    yv1=tensor_operator_apply( AM, xv );
%    yv2=tensor_operator_apply( A2, tensor_operator_apply( A1M, xv ) );
%    % should give all the same
%    [tkron(y1), tkron(y2), yv1, yv2, AM*xv, A2M*(A1M*xv)]
%    % should be zero 
%    norm( AM-tkron(A))
%
% See also LINEAR_OPERATOR_COMPOSE, TENSOR_OPERATOR_APPLY

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if isnumeric(A1) && isnumeric(A2)
    A=linear_operator_compose( A1, A2 );
elseif isnumeric(A1)
    A=linear_operator_compose( A1, tkron(A2) );
elseif isnumeric(A2)
    A=linear_operator_compose( tkron(A1), A2 );
else
    k1=size(A1,1);
    k2=size(A2,1);
    r=size(A1,2); % should be 2 currently
    A=cell(k1*k2,r);
    for i1=1:k1
        for i2=1:k2
            i=i2+(i1-1)*k2;
            for j=1:r
                A{i,j}=linear_operator_compose( A1{i1,j}, A2{i2,j} );
            end
        end
    end
end
