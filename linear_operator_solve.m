function x=linear_operator_solve( A, y )
%
% Example (<a href="matlab:run_example linear_operator_solve">run</a>)
%     M=[1, 2, 3; 3, 4, 6; 5, 10, 14];
%     linop={ size(M), {@mtimes, {M}, {1} } };
%     linop_inv={ linop{:}, {@mldivide, {M}, {1} } };
%     [m,n]=linear_operator_size( linop );
%
%     x=ones(n,1);
%     y=linear_operator_apply( linop, x ); 
%     x1=linear_operator_solve( linop_inv, y );
%     x2=linear_operator_solve( linop, y );
%     disp([y,x,x1,x2]);
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
