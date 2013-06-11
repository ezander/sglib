function unittest_cross_correlation
% UNITTEST_CROSS_CORRELATION Test the CROSS_CORRELATION function.
%
% Example (<a href="matlab:run_example unittest_cross_correlation">run</a>)
%    unittest_cross_correlations
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


munit_set_function( 'cross_correlation' );

assert_equals( cross_correlation( [[1;0;0] [1;1;1]], [ [0;2;0] [3;0;0]] ), ...
    [0 1; 1/sqrt(3) 1/sqrt(3)] );

assert_equals( cross_correlation( [[1;0;0] [1;1;1]], [ [0;2;0] [3;0;0]], eye(3) ), ...
    [0 1; 1/sqrt(3) 1/sqrt(3)] );

assert_equals( cross_correlation( [[1;0;0] [1;1;1]], [ [0;2;0] [3;0;0]], diag([2,2,2]) ), ...
    [0 1; 1/sqrt(3) 1/sqrt(3)] );
