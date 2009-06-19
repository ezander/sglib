function x=linear_operator_solve( A, y )
% LINEAR_OPERATOR_SOLVE Solve a linear equation for a general linear operator.
%   X=LINEAR_OPERATOR_SOLVE( A, Y ) solves the system of equations A*X=Y.
%   If the linear operator A is a concrete matrix the matlab \ operator is
%   used. If A is a general linear operator and the solve field is present
%   in the cell array (see LINEAR_OPERATOR), then this is used for solving.
%   If no solve field is present CGS is used with the apply field of the
%   linear operator A.
%
% Example (<a href="matlab:run_example linear_operator_solve">run</a>)
%     M=gallery( 'wathen', 3, 3 );
%     L=linear_operator( M );
%     y=ones(size(M,1),1);
%     x1=M\y;
%     x2=linear_operator_solve( M, y); % uses 
%     x3=linear_operator_solve( L, y); % uses L{3}
%     x4=linear_operator_solve( L(1:2), y); % uses cgs with L{2}
%     fprintf( '%g %g %g\n', norm(x1-x2), norm(x1-x3), norm(x1-x4) );
%
% See also LINEAR_OPERATOR, LINEAR_OPERATOR_SIZE, ISFUNCTION

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


if isnumeric(A)
    % A is a matrix 
    x=A\y;
elseif iscell(A) && length(A)>=3 && isfunction(A{3})
    % A is an operator and secondelement contains function returning the
    % application
    x=funcall( A{3}, y );
elseif iscell(A) && isfunction(A{2})
    % A is an operator and secondelement contains function returning the
    % application
    [x,flags] = cgs(@funcall_reverse,y,[],[],[],[],[],A{2});
    if flags
        % TODO: modify itermsg to work here
        warning( 'linear_operator_solve:no_convergence', 'cgs did not converge...' );
    end
    
else
    error( 'linear_operator_size:type', 'linear operator is neither a matrix nor a cell array' );
end

function y=funcall_reverse( x, func )
y=funcall( func, x );
