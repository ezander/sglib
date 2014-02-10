function unittest_trapezoidal_rule
% UNITTEST_TRAPEZOIDAL_RULE Test the TRAPEZOIDAL_RULE function.
%
% Example (<a href="matlab:run_example unittest_trapezoidal_rule">run</a>)
%   unittest_trapezoidal_rule
%
% See also TRAPEZOIDAL_RULE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'trapezoidal_rule' );

n = 15;
[x,w] = trapezoidal_rule(n);
assert_equals(size(x), [1, n+1], 'size_x');
assert_equals(size(w), [n+1, 1], 'size_w');
assert_equals(sum(w), 2, 'sum_w');
assert_equals(diff(diff(x)), zeros(1,n-1), 'equidist');
assert_equals(x([1,n+1]), [-1, 1], 'endpoints');

munit_set_function( 'trapezoidal_nested' );

assert_equals(trapezoidal_nested(1), [-1, 1], 'nested_1');
for i = 1:5
    x1 = trapezoidal_nested(i);
    x2 = trapezoidal_nested(i+1);
    assert_true(all(ismember(x1, x2)), [], sprintf('is_nested_%d', i));
end


[x0,w0] = trapezoidal_rule(4);
[x,w] = trapezoidal_rule(4, 'interval', [0, 1]);
assert_equals(x, (x0+1)/2, 'shifted_x');
assert_equals(w, w0/2, 'shifted_w');
