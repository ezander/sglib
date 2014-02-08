function unittest_polysys_int_rule
% UNITTEST_POLYSYS_INT_RULE Test the POLYSYS_INT_RULE function.
%
% Example (<a href="matlab:run_example unittest_polysys_int_rule">run</a>)
%   unittest_polysys_int_rule
%
% See also POLYSYS_INT_RULE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'polysys_int_rule' );


% Tables taken from: http://dlmf.nist.gov/3.5#v
[x, w] = polysys_int_rule('P', 5);
xw_ex = [[0.000000000000000, 0.568888888888889];
    [0.538469310105683, 0.478628670499366];
    [0.906179845938664, 0.236926885056189]];
assert_equals( [x(3:end), 2*w(3:end)'], xw_ex, 'P_5');



[x, w] = polysys_int_rule('L', 5);
xw_ex = [[0.263560319718141, 0.521755610582809];
    [0.141340305910652e1, 0.398666811083176];
    [0.359642577104072e1, 0.759424496817076e-1];
    [0.708581000585884e1, 0.361175867992205e-2];
    [0.126408008442758e2, 0.233699723857762e-4]];
assert_equals( [x, w'], xw_ex, 'L_5');

% check special case of very small rule (n=1)
[x, w] = polysys_int_rule('P', 1);
assert_equals( [x, w], [0, 1], 'P_1');

[x, w] = polysys_int_rule('L', 1);
assert_equals( [x, w], [1, 1], 'L_1');

% here we test that the x's are really zeros of the polynomials and the
% weights sum up to one
test_for_zeros('H', 5);
test_for_zeros('h', 5);
test_for_zeros('P', 5);
test_for_zeros('p', 5);
test_for_zeros('T', 5);
test_for_zeros('t', 5);
test_for_zeros('U', 5);
test_for_zeros('u', 5);
test_for_zeros('L', 5);
test_for_zeros('l', 5);


function test_for_zeros(sys, n)
[x, w] = polysys_int_rule(sys, n);
p = polysys_rc2coeffs(polysys_recur_coeff(sys, n));
p = p(end,:);
assert_equals(polyval(p,x), zeros(n,1), sprintf('zero_%s_%d', sys, n));
assert_equals(sum(w), 1, sprintf('sum_%s_%d_is_one', sys, n));
