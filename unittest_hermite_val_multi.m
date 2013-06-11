function unittest_hermite_val_multi
% UNITTEST_HERMITE_VAL_MULTI Test the hermite_val_multi function.
%
% Example (<a href="matlab:run_example unittest_hermite_val_multi">run</a>)
%    unittest_hermite_val_multi
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


munit_set_function( 'hermite_val_multi' );

x=linspace(0,1)';
y=rand(size(x));
z=rand(size(x));


assert_equals( hermite_val_multi( [1,0,0,0,0], [0;1;2;3;4],x), ones(size(x)), 'H0_d1' );
assert_equals( hermite_val_multi( [0,2.2,0,0,0], [0;1;2;3;4],x), 2.2*x, 'H1_d1' );
assert_equals( hermite_val_multi( [0,0,3.3,0,0], [0;1;2;3;4],x), 3.3*(x.^2-1), 'H2_d1' );


assert_equals( hermite_val_multi( [1,0,0,0,0,0], [0 0;1 0;0 1;2 0;1 1; 0 2],[x y]), ones(size(x)), 'H00_d2' );
assert_equals( hermite_val_multi( [0,1,0,0,0,0], [0 0;1 0;0 1;2 0;1 1; 0 2],[x y]), x, 'H10_d2' );
assert_equals( hermite_val_multi( [0,0,1,0,0,0], [0 0;1 0;0 1;2 0;1 1; 0 2],[x y]), y, 'H01_d2' );
assert_equals( hermite_val_multi( [0,0,0,1,0,0], [0 0;1 0;0 1;2 0;1 1; 0 2],[x y]), x.^2-1, 'H20_d2' );
assert_equals( hermite_val_multi( [0,0,0,0,1,0], [0 0;1 0;0 1;2 0;1 1; 0 2],[x y]), x.*y, 'H11_d2' );
assert_equals( hermite_val_multi( [0,0,0,0,0,1], [0 0;1 0;0 1;2 0;1 1; 0 2],[x y]), y.^2-1, 'H02_d2' );
assert_equals( hermite_val_multi( [1,2,3,4,5,6], [0 0;1 0;0 1;2 0;1 1; 0 2],[x y]), -9+2*x+3*y+4*x.^2+5*x.*y+6*y.^2, 'Hxx_d2' );

assert_equals( hermite_val_multi( [0,1], [0 0;3 2],[x y]), (x.^3-3*x).*(y.^2-1), 'H32_d2' );

assert_equals( hermite_val_multi( [0.7,1], [0 0 0;3 2 2],[x y z]), 0.7+(x.^3-3*x).*(y.^2-1).*(z.^2-1), 'H322_d3' );
