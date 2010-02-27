function [m,n]=linear_operator_size( A )
% LINEAR_OPERATOR_SIZE Return the size of a linear operator.
%   [M,N]=LINEAR_OPERATOR_SIZE( A ) returns the size of the linear operator
%   A. N is the size of the input vector and M is the size of the result
%   vector (i.e. A: R^N->R^M). If only one output argument is given the
%   function returns the result as a vector.
%
% Example (<a href="matlab:run_example linear_operator_size">run</a>)
%     M=[1, 2; 3, 4; 5, 10];
%     s=linear_operator_size( M ); disp(s);
%
%     linop={ size(M), {@mtimes, {M}, {1} } };
%     s=linear_operator_size( linop ); disp(s);
%
%     linop2={ { @size, {M}, {1} }, {@mtimes, {M}, {1} } };
%     s=linear_operator_size( linop2 ); disp(s);
%
% See also LINEAR_OPERATOR, LINEAR_OPERATOR_APPLY, ISFUNCTION

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
    % A is a matrix (meaningsless result for identity)
    m=size(A);
elseif iscell(A) && isnumeric(A{1})
    % A is an operator and first element is the size
    m=A{1};
else
    error( 'linear_operator_size:type', 'linear operator is neither a matrix nor a cell array' );
end

if nargout==2
    n=m(2); m=m(1);
end
