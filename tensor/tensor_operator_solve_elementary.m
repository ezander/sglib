function U=tensor_operator_solve_elementary( A, T )
% TENSOR_OPERATOR_SOLVE_ELEMENTARY Solves an equation with an elementary tensor operator.
%
% Example (<a href="matlab:run_example tensor_solve_elementary">run</a>)
%   % still to come
%
% See also TENSOR_OPERATOR_APPLY_ELEMENTARY

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isnumeric(T)
    U=A\T;
elseif iscell(T)
    % some assertions stuff comes here
    %U={ linear_operator_solve( A{1}, T{1} ), linear_operator_solve( A{2}, T{2} ) };
    U=cellfun( @linear_operator_solve, A, T, 'UniformOutput', false );
else
    error('unknown tensor type');
end
