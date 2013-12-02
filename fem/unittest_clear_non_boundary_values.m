function unittest_clear_non_boundary_values
% UNITTEST_CLEAR_NON_BOUNDARY_VALUES Test the CLEAR_NON_BOUNDARY_VALUES function.
%
% Example (<a href="matlab:run_example unittest_clear_non_boundary_values">run</a>)
%   unittest_clear_non_boundary_values
%
% See also CLEAR_NON_BOUNDARY_VALUES

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'clear_non_boundary_values' );


N = 10;
M = 23;
g_i_k = rand(N, M)+1;

bnd = [2, 5, 10];
b_i_k = clear_non_boundary_values(g_i_k, bnd);
assert_equals(b_i_k(bnd,:), g_i_k(bnd,:), 'same_on_bnd');
assert_equals(b_i_k(setdiff(1:N,bnd),:), zeros(N-length(bnd),M), 'else_zero');



