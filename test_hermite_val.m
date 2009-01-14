function test_hermite_val
% TEST_HERMITE_VAL Test the HERMITE_VAL function.
%
% Example 
%    test_hermite_val
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'hermite_val' );

x=linspace(0,1);

assert_equals( hermite_val( 1, x), ones(size(x)), 'H1' );
assert_equals( hermite_val( [1 0], x), ones(size(x)), 'H11' );
assert_equals( hermite_val( [1 0 0], x), ones(size(x)), 'H12' );
assert_equals( hermite_val( 2, x), 2*ones(size(x)), 'H1' );
assert_equals( hermite_val( [3 0 0], x), 3*ones(size(x)), 'H12' );

assert_equals( hermite_val( [0 1], x), x, 'H2' );
assert_equals( hermite_val( [0 2 0], x), 2*x, 'H2' );

assert_equals( hermite_val( [0 0 2], x), 2*(x.^2-1), 'H3' );
assert_equals( hermite_val( [0 0 0 3], x), 3*(x.^3-3*x), 'H4' );
assert_equals( hermite_val( [0 0 0 0 4], x), 4*(x.^4-6*x.^2+3), 'H5' );

assert_equals( hermite_val( [0 0 2]', x), 2*(x.^2-1), 'H3_trans1' );
x=x';
assert_equals( hermite_val( [0 0 2], x), 2*(x.^2-1), 'H3_trans2' );
assert_equals( hermite_val( [0 0 2]', x), 2*(x.^2-1), 'H3_trans3' );
