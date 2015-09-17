function unittest_find_poly_intervals
% UNITTEST_FIND_POLY_INTERVALS Test the FIND_POLY_INTERVALS function.
%
% Example (<a href="matlab:run_example unittest_find_poly_intervals">run</a>)
%   unittest_find_poly_intervals
%
% See also FIND_POLY_INTERVALS, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'find_poly_intervals' );

assert_equals(find_poly_intervals(poly([2,3,5]),0),  [[-inf;2],[3;5]], 'pos_odd');
assert_equals(find_poly_intervals(-poly([2,3]),0),   [[-inf;2],[3;inf]], 'neg_even');
assert_equals(find_poly_intervals(poly([2,3,5]),0),  [[-inf;2],[3;5]], 'pos_odd');
assert_equals(find_poly_intervals(-poly([2,3,5]),0), [[2;3],   [5;inf]], 'neg_odd');

assert_equals(find_poly_intervals(poly_add(poly([2,3,5]), pi),pi), [[-inf;2],[3;5]], 'add');
assert_equals(find_poly_intervals(poly([2,6]),-3), [3;5], 'non_empty');
assert_equals(find_poly_intervals(poly([2,6]),-5), zeros(2,0), 'empty');
assert_equals(find_poly_intervals(poly([2,6]),-4+1e-13), [4;4], 'nearly_empty', 'abstol', 1e-5);


assert_equals(find_poly_intervals(poly([0,0]), 0), zeros(2,0), 'double_root');
assert_equals(find_poly_intervals(poly([-1,-2,0,0,2,3,0,0]), 0), [[-2;-1],[2;3]], 'multi_root');



function p=poly_add(p,a)
p(end)=p(end)+a;
