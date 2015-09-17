function unittest_gendist_sample
% UNITTEST_GENDIST_SAMPLE Test the GENDIST_SAMPLE function.
%
% Example (<a href="matlab:run_example unittest_gendist_sample">run</a>)
%   unittest_gendist_sample
%
% See also GENDIST_SAMPLE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gendist_sample' );

% check sizes
dist = gendist_create('uniform', {0, 1});
assert_equals(size(gendist_sample(12, dist)), [12, 1], 'size_u1');
assert_equals(size(gendist_sample([3, 5], dist)), [3, 5], 'size_u2');
assert_equals(size(gendist_sample([3, 6, 7], dist)), [3, 6, 7], 'size_u2');

dist = gendist_create('normal', {0, 1});
assert_equals(size(gendist_sample(12, dist)), [12, 1], 'size_n1');
assert_equals(size(gendist_sample([3, 5], dist)), [3, 5], 'size_n2');
assert_equals(size(gendist_sample([3, 6, 7], dist)), [3, 6, 7], 'size_n2');

% check mean and var
munit_control_rand('seed', 63858);
dist = gendist_create('uniform', {3, 5}, 'shift', 2.3, 'scale', 1.7);
xi = gendist_sample(100000, dist);
[mn, vr] = gendist_moments(dist);
assert_equals(mean(xi), mn, 'mean_u', 'abstol', 0.005 );
assert_equals(std(xi), sqrt(vr), 'var_u', 'abstol', 0.02 );

munit_control_rand('seed', 63858);
dist = gendist_create('normal', {1.2, 0.9}, 'shift', 2.3, 'scale', 1.7);
xi = gendist_sample(100000, dist);
[mn, vr] = gendist_moments(dist);
assert_equals(mean(xi), mn, 'mean_u', 'abstol', 0.005 );
assert_equals(std(xi), sqrt(vr), 'var_u', 'abstol', 0.02 );
