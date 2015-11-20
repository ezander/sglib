function unittest_gpc_combine_inputs
% UNITTEST_GPC_COMBINE_INPUTS Test the GPC_COMBINE_INPUTS function.
%
% Example (<a href="matlab:run_example unittest_gpc_combine_inputs">run</a>)
%   unittest_gpc_combine_inputs
%
% See also GPC_COMBINE_INPUTS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpc_combine_inputs' );

% Combine input / testing with evaluation
V1 = gpcbasis_create('hh', 'p', 4);
a1_alpha = rand(2, gpcbasis_size(V1,1));

V2 = gpcbasis_create('p', 'p', 2, 'm', 3);
a2_alpha = rand(5, gpcbasis_size(V2,1));

[a_beta, V] = gpc_combine_inputs(a1_alpha, V1, a2_alpha, V2);

xi1 = gpcgerm_sample(V1, 10);
xi2 = gpcgerm_sample(V2, 10);
xi = [xi1; xi2];
s1 = gpc_evaluate(a1_alpha, V1, xi1);
s2 = gpc_evaluate(a2_alpha, V2, xi2);
s = gpc_evaluate(a_beta, V, xi);
assert_equals(s, [s1;s2], 'test_with_eval1');



%% Combine with empty 
V1 = gpcbasis_create('h', 'p', 2);
a1_alpha = rand(2, gpcbasis_size(V1,1));

V2 = gpcbasis_create('', 'p', 1, 'm', 0);
a2_alpha = 4;

[a_beta, V] = gpc_combine_inputs(a1_alpha, V1, a2_alpha, V2);
assert_equals(V, V1, 'no_change');
assert_equals(a_beta, [a1_alpha; a2_alpha, zeros(1,size(a1_alpha,2)-1)], 'add_det');

[a_beta, V] = gpc_combine_inputs(a2_alpha, V2, a1_alpha, V1);
assert_equals(V, V1, 'no_change');
assert_equals(a_beta, [a2_alpha, zeros(1,size(a1_alpha,2)-1); a1_alpha], 'add_det');
