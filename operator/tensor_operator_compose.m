function C=tensor_operator_compose( A, B )
% TENSOR_OPERATOR_COMPOSE Return the composition of two tensor operators.
%   C=TENSOR_OPERATOR_COMPOSE( A, B ) returns the composition C of the
%   tensor operators A and B such that C(X)=A(B(X))). If one of the
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
%    A1M=tensor_operator_to_matrix( A1 );
%    A2M=tensor_operator_to_matrix( A2 );
%    x={[1;2], [6;3;2]}; xv=revkron(x);
%    % in tensor format
%    A=tensor_operator_compose( A1, A2 )
%    y1=tensor_operator_apply( A, x );
%    y2=tensor_operator_apply( A2, tensor_operator_apply( A1, x ) );
%    % in Kronecker product/matrix format
%    AM=tensor_operator_compose( A1M, A2 )
%    yv1=tensor_operator_apply( AM, xv );
%    yv2=tensor_operator_apply( A2, tensor_operator_apply( A1M, xv ) );
%    % should give all the same
%    [revkron(y1), revkron(y2), yv1, yv2, AM*xv, A2M*(A1M*xv)]
%    % should be zero
%    norm( AM-tensor_operator_to_matrix(A))
%
% See also OPERATOR_COMPOSE, TENSOR_OPERATOR_APPLY

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

check_tensor_operator_format( A );
check_tensor_operator_format( B );
    

ka=size(A,1);
kb=size(B,1);
r=size(A,2);
C=cell(ka*kb,r);
for ia=1:ka
    for ib=1:kb
        i=ib+(ia-1)*kb;
        for j=1:r
            C{i,j}=operator_compose( A{ia,j}, B{ib,j} );
        end
    end
end

