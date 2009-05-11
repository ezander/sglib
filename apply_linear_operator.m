function [b,n]=apply_linear_operator( A, x )
% APPLY_LINEAR_OPERATOR Apply a linear operator or matrix to a vector.
%   B=APPLY_LINEAR_OPERATOR( A, X ) applies the linear operator A to the
%   vector X. If A is a matrix, then just A*X is returned, otherwise if A
%   is a function then, FUNCALL( A, X ) is returned. The functionality is
%   rather trivial but makes it easier to handle both "types" of linear
%   operator in solver codes. 
%   If the argument X is not supplied or empty the size of A is returned.
%   Thus, any linear operator function has to be implemented such that if
%   the second argument is empty, the size of the operator is returned.
%   (This is for calling code to make memory allocations and the like
%   without knowing details about the linear operator otherwise). Depending
%   on the number of output arguments, either a size array is returned, or
%   the individual dimensions are returned as different output arguments.
%
% Example
%     M=[1, 2; 3, 4; 5, 10];
%     x=[1; 5];
% 
%     y1=apply_linear_operator( M, x );
% 
%     % This doesn't fulfill the requirement for empty X, just for
%     % demonstration
%     func={ @times, {M}, {1} };
%     y2=apply_linear_operator( M, x );
%     disp([y1,y2,y1-y2])
%
% See also ISFUNCTION

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


if nargin<2
    x=[];
end
sizeonly=isempty( x );

if isnumeric(A)
    % assume A is a matrix 
    if sizeonly
        b=size(A);
    else
        b=A*x;
    end
elseif isfunction(A)
    % A is an operator (size query must be handled by A)
    b=funcall( A, x );
else
    error( 'apply_linear_operator:type', 'linear operator is neither a matrix nor a function' );
end

if sizeonly && nargout==2
    n=b(2); b=b(1);
end

