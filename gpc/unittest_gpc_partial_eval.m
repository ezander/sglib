function unittest_gpc_partial_eval
% UNITTEST_GPC_PARTIAL_EVAL Test the GPC_PARTIAL_EVAL function.
%
% Example (<a href="matlab:run_example unittest_gpc_partial_eval">run</a>)
%   unittest_gpc_partial_eval
%
% See also GPC_PARTIAL_EVAL, TESTSUITE 

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
I_a = multiindex(3, 4);
V_a = {'p', I_a};
n = 11;
k = 2;
a_i_alpha = randn(n, size(I_a, 1));

xi_a = gpc_sample(V_a);
[b_i_alpha, V_b] = gpc_partial_eval(a_i_alpha, V_a, k, xi_a(k));

xi_b = xi_a;
xi_b(k) = [];
assert_equals(gpc_evaluate(b_i_alpha, V_b, xi_b), gpc_evaluate(a_i_alpha, V_a, xi_a), 'eval');

% test with Hermite polynomials 
I_a = multiindex(5, 3);
V_a = {'H', I_a};
n = 7;
k = 4;
a_i_alpha = randn(n, size(I_a, 1));

xi_a = gpc_sample(V_a);
[b_i_alpha, V_b] = gpc_partial_eval(a_i_alpha, V_a, k, xi_a(k));

xi_b = xi_a;
xi_b(k) = [];
assert_equals(gpc_evaluate(b_i_alpha, V_b, xi_b), gpc_evaluate(a_i_alpha, V_a, xi_a), 'evalH');


% V_a = {'hHlPu', ...
% k = [1,3] xi(k)



