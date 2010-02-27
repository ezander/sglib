function C=linear_operator_compose( A, B )
% LINEAR_OPERATOR_COMPOSE Return the composition of two linear operators.
%   C=LINEAR_OPERATOR_COMPOSE( A, B ) returns the composition C of the
%   linear operators A and B such that C(X)=A(B(X))).
%   If the operators are both matrices then the matrix product is computed.
%   If you don't want this behaviour first call LINEAR_OPERATOR_FROM_MATRIX
%   on one of the operands--in this case the composition is an object that
%   performs the matrix multiplications step by step.
%
% Example (<a href="matlab:run_example linear_operator_compose">run</a>)
%
% See also LINEAR_OPERATOR, LINEAR_OPERATOR_APPLY, LINEAR_OPERATOR_SIZE

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

%check_match( linear_operator_size(A), linear_operator_size(B), true, 'A', 'B', mfilename );
check_match( A, B, true, 'A', 'B', mfilename );

if isempty(A)
    C=B;
elseif isempty(B)
    C=A;
elseif isnumeric(A) && isnumeric(B)
    % A and B are matrices
    C=A*B;
else
    sa=linear_operator_size(A);
    sb=linear_operator_size(B);
    C={[sa(1), sb(2)], {@comp_apply, {A,B}, {1,2}} };
end

function z=comp_apply( A, B, x )
y=linear_operator_apply( B, x );
z=linear_operator_apply( A, y );
