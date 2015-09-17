function unittest_bootstrap_sample
% UNITTEST_BOOTSTRAP_SAMPLE Test the BOOTSTRAP_SAMPLE function.
%
% Example (<a href="matlab:run_example unittest_bootstrap_sample">run</a>)
%   unittest_bootstrap_sample
%
% See also BOOTSTRAP_SAMPLE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'bootstrap_sample' );

x = ones(7, 1);

assert_equals(bootstrap_sample(x, 3, 5), ones(3, 5), 'shape_mn');
assert_equals(bootstrap_sample(x', 3, 5), ones(3, 5), 'shapeT_mn');
assert_equals(bootstrap_sample(x, 1, 5), ones(1, 5), 'shape_1n');
assert_equals(bootstrap_sample(x', 1, 5), ones(1, 5), 'shapeT_1n');
assert_equals(bootstrap_sample(x, 3, 1), ones(3, 1), 'shape_m1');
assert_equals(bootstrap_sample(x', 3, 1), ones(3, 1), 'shapeT_m1');
