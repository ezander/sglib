function unittest_lhs_uniform
% UNITTEST_LHS_UNIFORM Test the LHS_UNIFORM function.
%
% Example (<a href="matlab:run_example unittest_lhs_uniform">run</a>)
%   unittest_lhs_uniform
%
% See also LHS_UNIFORM, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'lhs_uniform' );

x = lhs_uniform(10, 1);
assert_equals(size(x), [10, 1], 'size1');
x = lhs_uniform(37, 5);
assert_equals(size(x), [37, 5], 'size2');

n=47; m=3;
x = lhs_uniform(n, m);
box = sort(floor(x * n), 1);
assert_equals(box, repmat((0:n-1)',1,m), 'boxes');
