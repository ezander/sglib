function unittest_clenshaw_curtis_legendre_rule
% UNITTEST_CLENSHAW_CURTIS_LEGENDRE_RULE Test the CLENSHAW_CURTIS_LEGENDRE_RULE function.
%
% Example (<a href="matlab:run_example unittest_clenshaw_curtis_legendre_rule">run</a>)
%   unittest_clenshaw_curtis_legendre_rule
%
% See also CLENSHAW_CURTIS_LEGENDRE_RULE, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'clenshaw_curtis_legendre_rule' );

k=5;
[x,w]=clenshaw_curtis_legendre_rule(k);
assert_equals( size(x,1), 1, 'x_row' );
assert_equals( size(w,2), 1, 'w_column' );
assert_equals( sum(w), max(x)-min(x), 'w_sum' );
assert_equals( sum(x*w), 0, 'int_ord1_ex' );
assert_equals( sum((x.^2)*w), 2/3, 'int_ord2_ex' );
assert_equals( sum((x.^3)*w), 0, 'int_ord3_ex' );
assert_equals( sum((x.^4)*w), 2/5, 'int_ord4_ex' );
assert_equals( sum((x.^14)*w), 2/15, 'int_ord14_ex' );
assert_equals( sum((x.^16)*w), 2/17, 'int_ord16_ex' );
