function unittest_clenshaw_curtis_rule
% UNITTEST_CLENSHAW_CURTIS_RULE Test the CLENSHAW_CURTIS_RULE function.
%
% Example (<a href="matlab:run_example unittest_clenshaw_curtis_rule">run</a>)
%   unittest_clenshaw_curtis_rule
%
% See also CLENSHAW_CURTIS_RULE, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'clenshaw_curtis_rule' );


[x,w]=clenshaw_curtis_rule(1);
assert_equals( size(x), [1, 1], 'x1_row' );
assert_equals( size(w), [1, 1], 'w1_column' );
assert_equals( sum(w), 2, 'w1_sum' );

[x,w]=clenshaw_curtis_rule(2);
assert_equals( size(x), [1, 2], 'x2_row2' );
assert_equals( size(w), [2, 1], 'w2_column' );
assert_equals( sum(w), 2, 'w2_sum' );

[x,w]=clenshaw_curtis_rule(3);
assert_equals( x, [-1, 0, 1], 'x3' );
assert_equals( w, [1; 4; 1]/3, 'w3' );

n = 17;
[x,w]=clenshaw_curtis_rule(n);
assert_equals( size(x), [1, 17], 'xn_row' );
assert_equals( size(w), [17, 1], 'wn_column' );
assert_equals( sum(w), 2, 'wn_sum' );

assert_equals( sum(x*w), 0, 'int_ord1_ex' );
assert_equals( sum((x.^2)*w), 2/3, 'int_ord2_ex' );
assert_equals( sum((x.^3)*w), 0, 'int_ord3_ex' );
assert_equals( sum((x.^4)*w), 2/5, 'int_ord4_ex' );
assert_equals( sum((x.^14)*w), 2/15, 'int_ord14_ex' );
assert_equals( sum((x.^16)*w), 2/17, 'int_ord16_ex' );



munit_set_function( 'clenshaw_curtis_nested' );

assert_equals(clenshaw_curtis_nested(1), [-1, 1], 'nested_1');
for i = 1:5
    x1 = clenshaw_curtis_nested(i);
    x2 = clenshaw_curtis_nested(i+1);
    assert_true(all(ismember(x1, x2)), [], sprintf('is_nested_%d', i));
end
