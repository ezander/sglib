function unittest_hermite_norm
% UNITTEST_HERMITE_NORM Test the HERMITE_NORM function.
%
% Example (<a href="matlab:run_example unittest_hermite_norm">run</a>)
%   unittest_hermite_norm
%
% See also HERMITE_NORM, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'hermite_norm' );

assert_equals( hermite_norm([0;1;2;3;4]), sqrt([1;1;2;6;24]), 'single' );

assert_equals( hermite_norm([2 2; 3 3; 5 5; 7 7]), [2;6;120;5040], 'mult' );

assert_equals( hermite_norm([1 2 3 4 2]), 4*3*2, 'mult2' );
