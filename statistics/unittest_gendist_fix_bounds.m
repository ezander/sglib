function unittest_gendist_fix_bounds
% UNITTEST_GENDIST_FIX_BOUNDS Test the GENDIST_FIX_BOUNDS function.
%
% Example (<a href="matlab:run_example unittest_gendist_fix_bounds">run</a>)
%   unittest_gendist_fix_bounds
%
% See also GENDIST_FIX_BOUNDS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gendist_fix_bounds' );

% test for the uniform distribution
dist = gendist_create('uniform', {2, 3}, 'shift', 3, 'scale', 0.5);
dist = gendist_fix_bounds(dist, 2, 4);
assert_equals(gendist_invcdf(0, dist), 2, 'uni_min');
assert_equals(gendist_invcdf(1, dist), 4, 'uni_max');

% test with quantiles for the normal distribution
dist = gendist_create('normal', {2, 3});
dist = gendist_fix_bounds(dist, 2, 4, 'q0', 0.001, 'q1', 0.5);
assert_equals(gendist_invcdf(0.001, dist), 2, 'nor_min');
assert_equals(gendist_invcdf(0.5, dist), 4, 'nor_max');
