function unittest_data_moments
% UNITTEST_DATA_MOMENTS Test the DATA_MOMENTS function.
%
% Example (<a href="matlab:run_example unittest_data_moments">run</a>)
%   unittest_data_moments
%
% See also DATA_MOMENTS, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'data_moments' );

x=ones(10,1);
[m,v]=data_moments( x );
assert_equals( [m,v], [1,0], 'const' );

x=[ones(10,1); -ones(10,1)];
[m,v,s,k]=data_moments( x );
assert_equals( [m,v,s], [0,20/19,0], 'twoval' );

% kurtosis is very inexact except for very high sample sizes
x=randn_sorted(100000);
[m,v,s,k]=data_moments( x );
assert_equals( [m,v,s,k], [0,1,0,0], 'gaussian', 'abstol', 1e-8*[1,1,1,1e6] );

