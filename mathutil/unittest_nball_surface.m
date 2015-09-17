function unittest_nball_surface(varargin)
% UNITTEST_NBALL_SURFACE Test the NBALL_SURFACE function.
%
% Example (<a href="matlab:run_example unittest_nball_surface">run</a>)
%   unittest_nball_surface
%
% See also NBALL_SURFACE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'nball_surface' );

V = nball_surface([1, 2, 3, 4, 5, 6]);
assert_equals(V, [2, 2*pi, 4*pi, 2*pi^2, 8*pi^2/3, pi^3], 'r=1');

V = nball_surface([1, 2, 3], 5);
assert_equals(V, [2, 2*pi*5, 4*pi*25], 'r=5');

V = nball_surface([2, 4, 3], [5, 6, 8]);
assert_equals(V, [2*pi*5, 2*pi^2*6^3, 4*pi*64], 'multi');

V = nball_surface([2; 4], [5, 8]);
assert_equals(V, [2*pi*5, 2*pi*8; 2*pi^2*125, 2*pi^2*512], 'broadcast');
