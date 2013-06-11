function unittest_uniform_raw_moments
% UNITTEST_UNIFORM_RAW_MOMENTS Test the UNIFORM_RAW_MOMENTS function.
%
% Example (<a href="matlab:run_example unittest_uniform_raw_moments">run</a>)
%   unittest_uniform_raw_moments
%
% See also UNIFORM_RAW_MOMENTS 

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


munit_set_function( 'uniform_raw_moments' );

expected=[ 1.0, 0.5, 0.33333333333333331, 0.25, 0.20000000000000001, ...
    0.16666666666666666, 0.14285714285714285, 0.125, 0.1111111111111111, ...
    0.10000000000000001, 0.090909090909090912];
assert_equals( expected, uniform_raw_moments( 0:10, 0, 1 ), 'a0b1' );

  
expected=[ 1.0, 2.6000000000000001, 7.1633333333333331, ...
    20.722000000000001, 62.349620000000009, 193.5102866666667];
assert_equals( expected(1+[3,1,5])', uniform_raw_moments( [3;1;5], 1.5, 3.7 ), 'a15b37' );

expected=[ 1, 2, 4, 8, 16];
assert_equals( expected, uniform_raw_moments( 0:4, 2, 2 ), 'a2b2' );
