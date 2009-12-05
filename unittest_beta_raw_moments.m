function unittest_beta_raw_moments
% UNITTEST_BETA_RAW_MOMENTS Test the BETA_RAW_MOMENTS function.
%
% Example (<a href="matlab:run_example unittest_beta_raw_moments">run</a>)
%   unittest_beta_raw_moments
%
% See also BETA_RAW_MOMENTS 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'beta_raw_moments' );

expected=[ 1.0, 0.5, 0.33333333333333331, 0.25, 0.20000000000000001, ...
    0.16666666666666666, 0.14285714285714285, 0.125, 0.1111111111111111, ...
    0.10000000000000001, 0.090909090909090912];
assert_equals( expected, beta_raw_moments( 0:10, 1, 1 ), 'a1b1' );

expected=[1.0, 0.33333333333333331, 0.14285714285714285, ...
      0.071428571428571425, 0.03968253968253968, 0.023809523809523808];
assert_equals( expected(1+[3;1;5])', beta_raw_moments( [3;1;5], 2, 4 ), 'a2b4T' );
