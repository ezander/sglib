function C=linear_operator_compose( A, B, varargin )
% LINEAR_OPERATOR_COMPOSE Return the composition of two linear operators.
%   C=LINEAR_OPERATOR_COMPOSE( A, B ) returns the composition C of the
%   linear operators A and B such that C(X)=A(B(X))). 
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

options=varargin2options( varargin{:} );
[step_solve,options]=get_option( options, 'step_solve', true );
check_unsupported_options( options, mfilename );


if isnumeric(A) && isnumeric(B)
    % A and B are matrices
    C=A*B;
else
    sa=linear_operator_size(A);
    sb=linear_operator_size(B);
    if step_solve
        C={[sa(1), sb(2)], {@comp_apply, {A,B}, {1,2}}, {@comp_solve, {A,B}, {1,2}} };
    else
        C={[sa(1), sb(2)], {@comp_apply, {A,B}, {1,2}} };
    end
end

function z=comp_apply( A, B, x )
y=linear_operator_apply( B, x );
z=linear_operator_apply( A, y );

function x=comp_solve( A, B, z )
y=linear_operator_solve( A, z );
x=linear_operator_solve( B, y );
