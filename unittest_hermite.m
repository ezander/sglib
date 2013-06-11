function unittest_hermite
% UNITTEST_HERMITE Test the HERMITE function.
%
% Example (<a href="matlab:run_example unittest_hermite">run</a>)
%    unittest_hermite
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


munit_set_function( 'hermite' );

% test explicitly polynomials up to order 6
assert_equals( hermite(0), 1, 'H1' );
assert_equals( hermite(1), [1 0], 'H2' );
assert_equals( hermite(2), [1 0  -1], 'H3' );
assert_equals( hermite(3), [1 0  -3 0], 'H4' );
assert_equals( hermite(4), [1 0  -6 0  3], 'H5' );
assert_equals( hermite(5), [1 0 -10 0 15  0], 'H6' );


% test recursion relation for order 10 and 20
assert_equals( hermite(10), [hermite(9)  0]-9*[0 0 hermite(8)], 'rec_10' );
assert_equals( hermite(20), [hermite(19)  0]-19*[0 0 hermite(18)], 'rec_20' );


% test generation of whole set of polynomials for order 7
H7=[
     0     0     0     0     0     0     0     1
     0     0     0     0     0     0     1     0
     0     0     0     0     0     1     0    -1
     0     0     0     0     1     0    -3     0
     0     0     0     1     0    -6     0     3
     0     0     1     0   -10     0    15     0
     0     1     0   -15     0    45     0   -15
     1     0   -21     0   105     0  -105     0
];
assert_equals( hermite(7,true), H7, 'H1-7' );
assert_equals( hermite(7,false), H7(8,:), 'H7f' );
