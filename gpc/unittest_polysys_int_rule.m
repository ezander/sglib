function unittest_polysys_int_rule
% UNITTEST_POLYSYS_INT_RULE Test the POLYSYS_INT_RULE function.
%
% Example (<a href="matlab:run_example unittest_polysys_int_rule">run</a>)
%   unittest_polysys_int_rule
%
% See also POLYSYS_INT_RULE, TESTSUITE 

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
x = polysys_int_rule(sys, n)';
p = polysys_rc2coeffs(polysys_recur_coeff(sys, n));
p = p(end,:);
assert_equals(polyval(p,x), zeros(1,n), sprintf('zero_%s_%d', sys, n));
