function d=operator_size( A )
% OPERATOR_SIZE Return the size of a linear operator.
%   D=OPERATOR_SIZE( A ) returns the size of the linear operator
%   A. 
%
% Example (<a href="matlab:run_example operator_size">run</a>)
%     M=[1, 2; 3, 4; 5, 10];
%     s=operator_size( M ); disp(s);
%
%     linop={ size(M), {@mtimes, {M}, {1} } };
%     s=operator_size( linop ); disp(s);
%
%     linop2={ { @size, {M}, {1} }, {@mtimes, {M}, {1} } };
%     s=operator_size( linop2 ); disp(s);
%
% See also OPERATOR, OPERATOR_APPLY, ISFUNCTION

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
    d=size(A);
elseif is_tensor_operator(A)
    d=tensor_operator_size( A, true );
elseif iscell(A) && isfunction(A{2})
    % A is an operator and first element is the size
    d=A{1};
else
    error( 'operator_size:type', 'linear operator is neither a matrix nor a cell array' );
end
