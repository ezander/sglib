function unittest_lognormal_raw_moments
% UNITTEST_LOGNORMAL_RAW_MOMENTS Test the LOGNORMAL_RAW_MOMENTS function.
%
% Example (<a href="matlab:run_example unittest_lognormal_raw_moments">run</a>)
%   unittest_lognormal_raw_moments
%
% See also LOGNORMAL_RAW_MOMENTS 

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


munit_set_function( 'lognormal_raw_moments' );

expected=[ 1., 1.6487212707001282, 7.38905609893065, 90.01713130052181, ...
    2980.9579870417283, 268337.2865208745, 6.565996913733051e7, ...
    4.3673179097646416e10, 7.896296018268069e13, 3.8808469624362035e17, ...
    5.184705528587072e21];
assert_equals( expected, lognormal_raw_moments( 0:10, 0, 1 ), 'mu0sig1' );


expected=[1.0, 3.472934799336826, 13.197138159658358, ...
    54.871824399070078, 249.63503718969369, 1242.6481670549958];
assert_equals( expected(1+[3,1,5])', lognormal_raw_moments( [3;1;5], 1.2, 0.3 ), 'mu12sig03' );
