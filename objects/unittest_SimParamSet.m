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

Q = SimParamSet();
Q.add('foo', NormalDistribution(2,3));
Q.add('bar', ExponentialDistribution(4));
Q.add('baz', LogNormalDistribution(1,1.2));
Q.add('quux', UniformDistribution(3,7), 'plot_name', 'QuuX');
Q.set_fixed('baz', 10)

assert_equals(Q.num_params, 4, 'num_params');
assert_equals(Q.find_rv(), logical([1;1;0;1]), 'ind_rv');
assert_equals(Q.find_fixed(), logical([0;0;1;0]), 'ind_fixed');
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

Q.set_normalized(false);
[Q_alpha, V_Q]=gpc_expand(Q);
assert_equals(Q_alpha, [42 0 0; 0.25 -0.25 0; 10 0 0; 5 0 2], 'gpc_expand_coeff');
assert_equals(V_Q, {'LP', [0 0; 1 0; 0 1]}, 'gpc_expand_basis');

Q.set_normalized();
Q.reset_fixed();
[~, V_Q]=gpc_expand(Q);
assert_equals(V_Q{1}, 'hLhp', 'gpc_expand_germ_normalized');

Q.set_to_mean('baz');
[~, V_Q]=gpc_expand(Q);
assert_equals(V_Q{1}, 'hLp', 'gpc_expand_germ_normalized');

%Q.sample(3)
%% Test the add_parameter method
Q = SimParamSet('prefer_normalized_polys', true);
Q.add_parameter(SimParameter('q1', NormalDistribution()), ...
    SimParameter('q2', UniformDistribution));
assert_equals(Q.get_param(1).name, 'q1', 'add_param1');
assert_equals(Q.get_param(2).name, 'q2', 'add_param2');

%% GPC methods
% Testing get_germ without fixed params
oldreg = gpc_registry('reset');
Q = SimParamSet('prefer_normalized_polys', true);
Q.add('q1', NormalDistribution(2,3));
Q.add('q2', ExponentialDistribution(4));
Q.add('q3', LogNormalDistribution(1,1.2));
Q.add('q4', UniformDistribution(3,7));
Q.add('q5', BetaDistribution(1,1.4));
Q.add('q6', BetaDistribution(1,1.2));
Q.add('q7', NormalDistribution(1,3));
Q.add('q8', BetaDistribution(1,1.4));

V_q = Q.get_germ();
assert_equals(V_q, gpcbasis_create('hLhpabha'), 'gpc_germ');

% Testing get_germ with fixed params
Q.set_to_mean('q2');
Q.set_to_mean('q5');
V_q = Q.get_germ();
assert_equals(V_q, gpcbasis_create('hhpbha'), 'gpc_germ_fixed');
gpc_registry('reset', oldreg);

% Testing the get_params
params = Q.get_params();
assert_equals(length(params), 8, 'get_params_num');
assert_equals(params{1}.name, 'q1', 'get_params1');
assert_equals(params{8}.name, 'q8', 'get_params8');

%% Basic statistical methods
Q = SimParamSet();
Q.add('q1', NormalDistribution(1,2));
Q.add('q2', NormalDistribution(2,3));
Q.add('q3', NormalDistribution(3,4));
Q.add('q4', NormalDistribution(4,5));
Q.set_fixed(3, 7);

assert_equals(Q.mean, [1; 2; 7; 4], 'mean');
assert_equals(Q.var, [4; 9; 0; 25], 'var');
prob1 = normal_pdf(1,1,2)*normal_pdf(2,2,3)*normal_pdf(4,4,5);
prob3 = normal_pdf(2,1,2)*normal_pdf(3,2,3)*normal_pdf(5,4,5);
assert_equals(Q.pdf([1 1 2; 2 2 3; 7 6 7; 4 4 5]), [prob1, 0, prob3], 'pdf');

%% Germ2params and params2germ
Q = SimParamSet();
Q.add('q1', UniformDistribution(1,2));
Q.add('q2', NormalDistribution(2,3));
Q.add('q3', LogNormalDistribution(3,4));
Q.set_fixed(2, 7);
N = 10;

xi = [linspace(-1, 1, N); linspace(-2, 2, N)];
q =  [linspace( 1, 2, N); repmat(7, 1, N); exp(3+4*linspace(-2, 2, N))];
assert_equals(Q.germ2params(xi), q, 'germ2params');
assert_equals(Q.params2germ(q), xi, 'params2germ');

%% Integration points
Q = SimParamSet();
Q.add('q1', UniformDistribution(1,2));
Q.add('q2', NormalDistribution(2,3));
Q.add('q3', LogNormalDistribution(3,4));
Q.set_fixed(2, 7);

[q,w,x] = Q.get_integration_points(3, 'grid', 'full_tensor');
[xe, we] = gpc_integrate([], gpcbasis_create('ph'), 3, 'grid', 'full_tensor');
qe =  [0.5*xe(1,:)+1.5; repmat(7, 1, length(we)); exp(3+4*xe(2,:))];

assert_equals(x, xe, 'integrate_ref_points');
assert_equals(w, we, 'integrate_ref_weights');
assert_equals(q, qe, 'integrate_points');

%% Sampling
Q = SimParamSet();
Q.add('q1', UniformDistribution(1,2));
Q.add('q2', NormalDistribution(2,3));
Q.add('q3', LogNormalDistribution(3,4));
Q.set_fixed(2, 7);

munit_control_rand('seed', 1234);
N=100000;
[q,xi] = Q.sample(N);
p1 = UniformDistribution(1,2);
p2 = LogNormalDistribution(3,4);
assert_equals(p1.cdf(sort(q(1,:))), linspace_midpoints(0,1,N), 'sample_q1', 'abstol', 1e-2);
assert_equals(q(2,:), repmat(7,1,N), 'sample_q2');
assert_equals(p2.cdf(sort(q(3,:))), linspace_midpoints(0,1,N), 'sample_q3', 'abstol', 1e-2);

p1 = UniformDistribution(-1, 1);
p2 = NormalDistribution();
assert_equals(p1.cdf(sort(xi(1,:))), linspace_midpoints(0,1,N), 'sample_xi1', 'abstol', 1e-2);
assert_equals(p2.cdf(sort(xi(2,:))), linspace_midpoints(0,1,N), 'sample_xi3', 'abstol', 1e-2);


%% Obsolete functions
% Not tested, just run to get the 100%
Q = SimParamSet();
p1 = SimParameter('p1', NormalDistribution(2,3));
p2 = SimParameter('p2', UniformDistribution(3,4));
Q.add_parameter(p1, p2);

assert_equals(Q.tostring(), '{Param("p1", N(2, 9)), Param("p2", U(3, 4))}', 'tostring');
assert_equals(Q.tostring('as_cell_array', true), {'Param("p1", N(2, 9))'; 'Param("p2", U(3, 4))'}, 'tostring_as_cell');

%% Obsolete functions
% Not tested, just run to get the 100%
Q = SimParamSet('prefer_normalized_polys', true);
Q.add('q1', NormalDistribution(2,3));

s = warning;
warning('off', 'sglib:obsolete:SimParamSet_get_gpcgerm');
Q.get_gpcgerm();
warning(s);


