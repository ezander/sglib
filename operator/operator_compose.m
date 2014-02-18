function C=operator_compose( A, B, varargin )
% OPERATOR_COMPOSE Return the composition of two linear operators.
%   C=OPERATOR_COMPOSE( A, B ) returns the composition C of the
%   linear operators A and B such that C(X)=A(B(X))).
%   If the operators are both matrices then the matrix product is computed.
%   If you don't want this behaviour first call OPERATOR_FROM_MATRIX
%   on one of the operands--in this case the composition is an object that
%   performs the matrix multiplications step by step.
%
% Example (<a href="matlab:run_example operator_compose">run</a>)
%
% See also OPERATOR, OPERATOR_APPLY, OPERATOR_SIZE

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

check_match( A, B, true, 'A', 'B', mfilename );

options = varargin2options(varargin);
[tensor_sum, options] = get_option(options, 'tensor_sum', true);
check_unsupported_options(options);


if isempty(A)
    C=B;
elseif isempty(B)
    C=A;
elseif isnumeric(A) && isnumeric(B)
    % A and B are matrices
    C=A*B;
elseif tensor_sum && is_tensor_operator(A) && is_tensor_operator(B)
    C=tensor_operator_compose( A, B );
else
    sa=operator_size(A);
    sb=operator_size(B);
    C=operator_from_function( {@comp_apply, {A,B}, {1,2}}, [sa(:,1), sb(:,2)] );
end

function z=comp_apply( A, B, x, varargin )
y=operator_apply( B, x, 'pass_on', varargin );
z=operator_apply( A, y, 'pass_on', varargin );
