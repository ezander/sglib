function unittest_format_poly
% UNITTEST_FORMAT_POLY Test the FORMAT_POLY functions.
%
% Example (<a href="matlab:run_example unittest_format_poly">run</a>)
%    unittest_format_poly
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'format_poly' );

assert_equals( format_poly( [1] ), '1', 'const 1' ); %#ok [1]
assert_equals( format_poly( [0 0 0 0] ), '0', 'zero' );
assert_equals( format_poly( [1 0 3 0 5 0] ), 'x^5+3x^3+5x', 'poly' );
assert_equals( format_poly( [0 1 0 3 0 5], 'symbol', 'z' ), 'z^4+3z^2+5', 'polyz' );

assert_equals( format_poly( [2 -3 -4] ), '2x^2-3x-4', 'minus' );
assert_equals( format_poly( [-2 -3 -4] ), '-2x^2-3x-4', 'minus' );
assert_equals( format_poly( [2 3 4], 'tight', false ), '2x^2 + 3x + 4', 'tight' );
assert_equals( format_poly( [-2 -3 -4], 'tight', false ), '-2x^2 - 3x - 4', 'tight-minus' );

options.tight=false;
options.twoline=true;
options.symbol='u';
assert_equals( format_poly( [-1 -1 -1], options ), ['  2        '; '-u  - u - 1'], 'twoline' );
assert_equals( format_poly( [1 1 1], options ), [' 2        '; 'u  + u + 1'], 'twoline' );

% multiple polynomials
assert_equals( format_poly( [1 2 3; 0 -4 0] ), { 'x^2+2x+3', '-4x'}, 'multi' );
assert_equals( format_poly( [1 2 3; 0 -4 0], 'symbol', 't', 'tight', false ), { 't^2 + 2t + 3', '-4t'}, 'multi_opt' );

% with and without rats
assert_equals( format_poly( [1.4 0.5 1/3], 'rats', true ), '7/5x^2+1/2x+1/3', 'rats_true' );
assert_equals( format_poly( [1.4 0.5 1/3], 'rats', false ), '1.4x^2+0.5x+0.33333', 'rats_false' );

% no return value if not wanted
if ismatlab
  assert_equals( evalc( 'format_poly( 1 )' ), sprintf('1\n'), 'noretval' );
  assert_equals( evalc( 'format_poly( eye(2) )' ), sprintf('x\n1\n'), 'noretval_mult' );
end
