function unittest_exponential_raw_moments
% UNITTEST_EXPONENTIAL_RAW_MOMENTS Test the EXPONENTIAL_RAW_MOMENTS function.
%
% Example (<a href="matlab:run_example unittest_exponential_raw_moments">run</a>)
%   unittest_exponential_raw_moments
%
% See also EXPONENTIAL_RAW_MOMENTS 

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


munit_set_function( 'exponential_raw_moments' );

expected=[1., 0.7692307692307692, 1.1834319526627217, 2.7309968138370504, 8.403067119498616, 32.31948892114852];
assert_equals( expected, exponential_raw_moments( 0:5, 1.3 ), 'lam1.3' );

expected=[750;5;375000];
assert_equals( expected, exponential_raw_moments( [3;1;5], 0.2 ), 'lam0.2T' );
