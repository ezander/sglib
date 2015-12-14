function unittest_SimParameter(varargin)
% UNITTEST_SIMPARAMETER Test the SIMPARAMETER function.
%
% Example (<a href="matlab:run_example unittest_SimParameter">run</a>)
%   unittest_SimParameter
%
% See also SIMPARAMETER, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
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

%% Handle object behaviour
q1=SimParameter('q', UniformDistribution(4, 10));
q1_alias=q1;
q2=q1.copy();
q1.set_fixed(10);

assert_true(q1.is_fixed, 'q1 should be fixed', 'param_fixed');
assert_true(q1_alias.is_fixed, 'q1_alias should be fixed', 'alias_fixed');
assert_false(q2.is_fixed, 'copy q2 should not be fixed', 'copy_not_fixed');

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

%% Testing the gpc for a stock distribution
q=SimParameter('q1', UniformDistribution(4, 10));
assert_equals(q.get_gpc_dist(), UniformDistribution(-1,1), 'germ_dist');

assert_equals(q.get_gpc_syschar(), 'p', 'syschar1');
assert_equals(q.get_gpc_syschar(true), 'p', 'syschar2');
assert_equals(q.get_gpc_syschar(false), 'P', 'syschar3');

[q_alpha, V_q]=gpc_expand(q);
assert_equals(q_alpha, [7, sqrt(3)], 'gpc_expand_coeff');
assert_equals(V_q, {'p', [0; 1]}, 'gpc_expand_V');

[q_alpha, V_q]=gpc_expand(q, 'normalized', false);
assert_equals(q_alpha, [7, 3], 'gpc_expand_coeff2');
assert_equals(V_q, {'P', [0; 1]}, 'gpc_expand_V2');

%% Testing the gpc for a non-stock distribution

q=SimParameter('q1', BetaDistribution(2, 3.2));
assert_equals(q.get_gpc_dist(), BetaDistribution(2, 3.2), 'germ_dist');

%% Test for a (now fixed) bug in pdf
q=SimParameter('q1', UniformDistribution(4, 10));
x0 = -100; delta=1e-5;
q.set_fixed(-100);
assert_equals(q.pdf([x0 - delta, x0, x0 + delta]), [0, 1, 0], 'germ_pdf_neg');
%assert_equals(q.cdf([x0 - delta, x0, x0 + delta]), [0, 1, 1], 'germ_cdf_neg');

