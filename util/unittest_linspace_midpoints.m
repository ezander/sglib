function unittest_linspace_midpoints(varargin)
% UNITTEST_LINSPACE_MIDPOINTS Test the LINSPACE_MIDPOINTS function.
%
% Example (<a href="matlab:run_example unittest_linspace_midpoints">run</a>)
%   unittest_linspace_midpoints
%
% See also LINSPACE_MIDPOINTS, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'linspace_midpoints' );

xm = linspace_midpoints(0, 1, 1);
assert_equals(xm, 0.5, 'one');

[xm, x] = linspace_midpoints(0, 1, 4);
assert_equals(xm, [0.125, 0.375, 0.625, 0.875], 'four');
assert_equals(x, [0, 0.25, 0.5, 0.75, 1], 'four2');

[~, x] = linspace_midpoints(2, 5);
assert_equals(x, linspace(2, 5, 101), 'oneoone');
