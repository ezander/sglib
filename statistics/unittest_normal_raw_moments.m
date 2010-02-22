function unittest_normal_raw_moments
% UNITTEST_NORMAL_RAW_MOMENTS Test the NORMAL_RAW_MOMENTS function.
%
% Example (<a href="matlab:run_example unittest_normal_raw_moments">run</a>)
%   unittest_normal_raw_moments
%
% See also NORMAL_RAW_MOMENTS 

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


munit_set_function( 'normal_raw_moments' );

expected=[1, 0, 1, 0, 3, 0, 15, 0, 105, 0, 945];
assert_equals( expected, normal_raw_moments( 0:10, 0, 1 ), 'mu0sig1' );

expected=[1.022, 0.2, 8.70382];
assert_equals( expected, normal_raw_moments( [3;1;5], 0.2, 1.3 ), 'lam0.2T' );
