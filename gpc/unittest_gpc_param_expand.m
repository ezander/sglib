function unittest_gpc_param_expand
% UNITTEST_GPC_PARAM_EXPAND Test the GPC_PARAM_EXPAND function.
%
% Example (<a href="matlab:run_example unittest_gpc_param_expand">run</a>)
%   unittest_gpc_param_expand
%
% See also GPC_PARAM_EXPAND, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpc_param_expand' );

%%
% Some tests with the combination lognormal/normal for which the expansion
% is known analytically (see third case)
a_dist=gendist_create('lognormal', {0, 1});
a_alpha = gpc_param_expand(a_dist, 'H', 'p', 7);
a_alpha_ex=exp(1/2)./factorial(0:7);
assert_equals(a_alpha, a_alpha_ex, 'lognorm1', 'abstol', 1e-5);

a_dist=gendist_create('lognormal', {1, 1});
a_alpha = gpc_param_expand(a_dist, 'H', 'p', 7);
a_alpha_ex=exp(3/2)./factorial(0:7);
assert_equals(a_alpha, a_alpha_ex, 'lognorm2', 'abstol', 1e-5);

mu=0.3; sigma=0.7;
a_dist=gendist_create('lognormal', {mu, sigma});
a_alpha = gpc_param_expand(a_dist, 'H', 'p', 7);
a_alpha_ex=exp(mu+(sigma^2)/2) * sigma.^(0:7)./factorial(0:7);
assert_equals(a_alpha, a_alpha_ex, 'lognorm3');


%%
% Now some studies whether the options are correctly evaluated

a_dist=gendist_create('lognormal', {0.2, 1.2});
[a_alpha, V_a, varerr] = gpc_param_expand(a_dist, 'H', 'p', 9);
[mu,var]=gendist_moments(a_dist);
assert_equals(a_alpha(1), mu, 'mean');
assert_equals(abs(var-gpc_moments(a_alpha, V_a, 'var_only', true)), varerr, 'varerr');
assert_equals(V_a{1}, 'H', 'syschar');

a_dist=gendist_create('lognormal', {0.2, 0.3});
[a_alpha, V_a, varerr] = gpc_param_expand(a_dist, 'H', 'varerr', 1e-5); %#ok<ASGLU>
assert_true(varerr<1e-5, 'Variance error too high', 'varerr_opt');

a_dist=gendist_create('lognormal', {0.2, 1.2});
[a_alpha, V_a, varerr] = gpc_param_expand(a_dist, 'H', 'fixvar', true);
[mu,var]=gendist_moments(a_dist);
assert_equals(a_alpha(1), mu, 'mean2');
assert_equals(var, gpc_moments(a_alpha, V_a, 'var_only', true), 'fixvar');
assert_equals(varerr, 0, 'fixvar0');



