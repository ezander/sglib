function unittest_gpc_sobol_partial_vars
% UNITTEST_GPC_SOBOL_PARTIAL_VARS Test the GPC_SOBOL_PARTIAL_VARS function.
%
% Example (<a href="matlab:run_example unittest_gpc_sobol_partial_vars">run</a>)
%   unittest_gpc_sobol_partial_vars
%
% See also GPC_SOBOL_PARTIAL_VARS, MUNIT_RUN_TESTSUITE 

%   Noemi Friedman, Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpc_sobol_partial_vars' );


%%
N = 5;
V_a = gpcbasis_create('HpL', 'p', 3);
a_i_alpha = rand(N, gpcbasis_size(V_a,1));

[partial_var, I_s, ratio_by_index, ratio_by_order]=gpc_sobol_partial_vars(a_i_alpha, V_a);

assert_equals(I_s(1:3,:), logical(eye(3)), 'ordering first sobol vars');
assert_equals(sum(I_s,2), [1,1,1,2,2,2,3]', 'ordering sobol vars');

I_a = V_a{2};
%sqr_norm=gpcbasis_norm(V_a)'.^2
sqr_norm=[1,1,1,1,2,1,1,1,1,1,6,2,1,1,2,1,1,1,1,1];
var_a_alpha = a_i_alpha.^2 .* repmat(sqr_norm, N, 1);

ind1 = I_a(:,1)>0 & I_a(:,2)==0 & I_a(:,3)==0;
assert_equals(partial_var(:,1), sum(var_a_alpha(:,ind1),2), 'sum_var_1');
ind23 = I_a(:,1)==0 & I_a(:,2)>0 & I_a(:,3)>0;
assert_equals(partial_var(:,6), sum(var_a_alpha(:,ind23),2), 'sum_var_1');

assert_equals(sum(ratio_by_index,2), ones(N,1), 'ratios_sum_to_1');
assert_equals(size(ratio_by_index), [N, size(I_s,1)], 'ratios_size')
assert_equals(sum(ratio_by_order,2), ones(N,1), 'ratios_sum_to_1');
assert_equals(size(ratio_by_order), [N, max(sum(I_s,2))], 'ratios_size')

%% Limited to order 1
[partial_var, I_s, ratio_by_index, ratio_by_order]=gpc_sobol_partial_vars(a_i_alpha, V_a, 'max_index', 1);
assert_equals(I_s, logical(eye(3)), 'sobol vars');

assert_equals(sum(ratio_by_index,2), ones(N,1), 'ratios_sum_to_1');
assert_equals(size(ratio_by_index), [N, size(I_s,1)], 'ratios_size')
assert_equals(sum(ratio_by_order,2), ones(N,1), 'ratios_sum_to_1');
assert_equals(size(ratio_by_order), [N, max(sum(I_s,2))], 'ratios_size')

