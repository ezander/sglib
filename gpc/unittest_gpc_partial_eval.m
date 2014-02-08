function unittest_gpc_partial_eval
% UNITTEST_GPC_PARTIAL_EVAL Test the GPC_PARTIAL_EVAL function.
%
% Example (<a href="matlab:run_example unittest_gpc_partial_eval">run</a>)
%   unittest_gpc_partial_eval
%
% See also GPC_PARTIAL_EVAL, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpc_partial_eval' );

% test with Legendre polynomials 
V_a = {'p', multiindex(3, 4)};
test_eval(V_a, 11, 2, 'evalP', true)

% test with Hermite polynomials 
V_a = {'H', multiindex(5, 3)};
test_eval(V_a, 7, 4, 'evalH4')

% test boundary cases
V_a = {'H', multiindex(5, 3)};
test_eval(V_a, 7, 1, 'evalH1')
test_eval(V_a, 7, 5, 'evalH5')

% test boundary cases
V_a = {'H', multiindex(5, 3)};
test_eval(V_a, 7, 1, 'evalH1')
test_eval(V_a, 7, 5, 'evalH5')

% test with strange multiindex set
V_a = {'H', [multiindex(3, 2), multiindex(3, 2)]};
test_eval(V_a, 11, 2, 'eval_m2')

% test with multiple vars
V_a = {'L', multiindex(7,3)};
test_eval(V_a, 11, [1,3,4], 'eval_m3', true)
test_eval(V_a, 11, [7,6,3], 'eval_m3dec')

% Test with heterogeneous polynomials
V_a = {'uHplP', multiindex(5,3)};
test_eval(V_a, 11, 3, 'eval_het1', true)
test_eval(V_a, 11, [5, 1, 2], 'eval_het2')



function test_eval(V_a, n, k, label, test_uniq)
I_a = V_a{2};
a_i_alpha = randn(n, size(I_a, 1));

xi_a = gpcgerm_sample(V_a);
[b_i_alpha, V_b] = gpc_partial_eval(a_i_alpha, V_a, k, xi_a(k));

xi_b = xi_a;
xi_b(k) = [];
assert_equals(gpc_evaluate(b_i_alpha, V_b, xi_b), gpc_evaluate(a_i_alpha, V_a, xi_a), label);

if nargin>=5 && test_uniq
    assert_equals(size(unique(V_b{2}, 'rows')), size(V_b{2}), [label, '_uniq']);
end
