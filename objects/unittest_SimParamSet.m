function unittest_SimParamSet(varargin)
% UNITTEST_SIMPARAMSET Test the SIMPARAMSET function.
%
% Example (<a href="matlab:run_example unittest_SimParamSet">run</a>)
%   unittest_SimParamSet
%
% See also SIMPARAMSET, MUNIT_RUN_TESTSUITE 

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



%[Q_alpha, V_Q, varserr]=gpc_expand_RVs(Q)
