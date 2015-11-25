function unittest_SimParamSet(varargin)
% UNITTEST_SIMPARAMSET Test the SIMPARAMSET function.
%
% Example (<a href="matlab:run_example unittest_SimParamSet">run</a>)
%   unittest_SimParamSet
%
% See also SIMPARAMSET, MUNIT_RUN_TESTSUITE 

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

%%
munit_set_function( 'SimParamSet' );

clear all
Q = SimParamSet();
Q.add('foo', NormalDistribution(2,3));
Q.add('bar', ExponentialDistribution(4));
Q.add('baz', LogNormalDistribution(1,1.2));
Q.add('quux', UniformDistribution(3,7), 'plot_name', 'QuuX');
Q.set_fixed('baz', 10)

assert_equals(Q.num_params, 4, 'num_params');
assert_equals(Q.find_ind_rv, logical([1;1;0;1]), 'ind_rv');
assert_equals(Q.num_rv, 3, 'num_rvs');

assert_equals(Q.param_names, {'foo', 'bar', 'baz', 'quux'}', 'params_names');
assert_equals(Q.param_plot_names, {'foo', 'bar', 'baz', 'QuuX'}', 'plot_names');
assert_equals(Q.rv_names, {'foo', 'bar', 'quux'}', 'rv_names');
assert_equals(Q.rv_plot_names, {'foo', 'bar', 'QuuX'}', 'rv_plot_names');


Q.set_not_fixed('baz')
assert_equals(Q.num_rv, 4, 'num_rvs2');
Q.set_fixed('baz', 10)
Q.set_dist('baz', LogNormalDistribution(1.1, 1.3));
assert_equals(Q.num_rv, 4, 'num_rvs3');
assert_equals(Q.get_param('baz').dist, LogNormalDistribution(1.1, 1.3), 'set_dist');
assert_equals(Q.get_param(3).dist, LogNormalDistribution(1.1, 1.3), 'set_dist');


Q.set_fixed(1, 42)
Q.set_fixed('baz', 10)
assert_equals(Q.get_fixed_vals(), [42; 10], 'get_fixed');

[Q_alpha, V_Q]=gpc_expand(Q, 'normalized', false);
assert_equals(Q_alpha, [42 0 0; 0.25 -0.25 0; 10 0 0; 5 0 2], 'gpc_expand_coeff');
assert_equals(V_Q, {'LP', [0 0; 1 0; 0 1]}, 'gpc_expand_basis');

%Q.sample(3)
