function unittest_SimParameter(varargin)
% UNITTEST_SIMPARAMETER Test the SIMPARAMETER function.
%
% Example (<a href="matlab:run_example unittest_SimParameter">run</a>)
%   unittest_SimParameter
%
% See also SIMPARAMETER, MUNIT_RUN_TESTSUITE 

%   <author>
%   Copyright 2015, <institution>
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'SimParameter' );

%% Generating a parameter and doing some fixing/unfixing
q=SimParameter('foo', NormalDistribution(2,3));
assert_equals(q.tostring(), 'Param("foo", N(2, 9))', 'tostring');
assert_false(q.is_fixed, 'q should not be fixed', 'not fixed');

q.set_fixed(12);
assert_true(q.is_fixed, 'q should be fixed now', 'fixed');
assert_equals(q.tostring(), 'Param("foo", 12)', 'tostring_fixed');

q.set_not_fixed();
assert_equals(q.tostring(), 'Param("foo", N(2, 9))', 'tostring');
assert_false(q.is_fixed, 'q should not be fixed', 'not fixed');

q.set_to_mean();
assert_true(q.is_fixed, 'q should be fixed now', 'fixed');
assert_equals(q.fixed_val, 2, 'meanval');

q.set_dist(UniformDistribution(4, 8));
assert_equals(q.tostring(), 'Param("foo", U(4, 8))', 'tostring');
assert_false(q.is_fixed, 'q should not be fixed', 'not fixed');

%% Testing the mean, var and sample functions
qv=SimParameter('q1', UniformDistribution(4, 10));
qf=SimParameter('q2', UniformDistribution(4, 10));
qf.set_fixed(100);

assert_equals(qv.mean(), 7, 'mean');
assert_equals(qf.mean(), 100, 'mean_fixed');

assert_equals(qv.var(), 3, 'var');
assert_equals(qf.var(), 0, 'var_fixed');

munit_control_rand('seed', 9999);
xi = qv.sample(100000);
assert_equals(sort(xi), linspace(4,10,length(xi))', 'sample_dist', 'abstol', 3e-2);
assert_equals(size(qv.sample(10)), [10,1], 'sample_shape_vec');
assert_equals(size(qv.sample([2,3])), [2,3], 'sample_shape_mat');

assert_equals(qf.sample(33), repmat(100, 33, 1), 'fixed_sample_vec');
assert_equals(qf.sample([2, 3]), repmat(100, 2, 3), 'fixed_sample_mat');


%% Testing the sampling function
