function unittest_nball_volume(varargin)
% UNITTEST_NBALL_VOLUME Test the NBALL_VOLUME function.
%
% Example (<a href="matlab:run_example unittest_nball_volume">run</a>)
%   unittest_nball_volume
%
% See also NBALL_VOLUME, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'nball_volume' );


assert_equals(nball_volume(0), 1, 'n=0');
assert_equals(nball_volume(1), 2, 'n=1');
assert_equals(nball_volume(2), pi, 'n=2');
assert_equals(nball_volume(3), 4/3*pi, 'n=3');

V = nball_volume([0, 1, 2, 3, 4, 5, 6]);
assert_equals(V, [1, 2, pi, 4/3*pi, pi^2/2, 8*pi^2/15, pi^3/6], 'r=1');

V = nball_volume([0, 1, 2], 5);
assert_equals(V, [1, 2*5, pi*25], 'r=5');

V = nball_volume([1, 3, 2], [5, 6, 8]);
assert_equals(V, [2*5, 4/3*pi*6^3, pi*64], 'multi');

V = nball_volume([1; 3], [5, 8]);
assert_equals(V, [2*5, 2*8; 4/3*pi*125, 4/3*pi*512], 'broadcast');


