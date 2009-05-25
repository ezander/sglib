function M=linear_operator_compose( M2, M1, varargin )
% LINEAR_OPERATOR_COMPOSE Return the composition of two linear operators.
%   M=LINEAR_OPERATOR_COMPOSE( M2, M1 ) returns the composition M of the
%   linear operators M1 and M2 such that M(X)=M2(M1(X))). 
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


if isnumeric(M1) && isnumeric(M2)
    % M1 and M2 are matrices
    M=M2*M1;
else
    s1=linear_operator_size(M1);
    s2=linear_operator_size(M2);
    if step_solve
        M={[s2(1), s1(2)], {@comp_apply, {M1,M2}, {1,2}}, {@comp_solve, {M1,M2}, {1,2}} };
    else
        M={[s2(1), s1(2)], {@comp_apply, {M1,M2}, {1,2}} };
    end
end

function z=comp_apply( M1, M2, x )
y=linear_operator_apply( M1, x );
z=linear_operator_apply( M2, y );

function x=comp_solve( M1, M2, z )
y=linear_operator_solve( M2, z );
x=linear_operator_solve( M1, y );
