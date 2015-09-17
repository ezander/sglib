function unittest_ifelse
% UNITTEST_IFELSE Test the IFELSE function.
%
% Example (<a href="matlab:run_example unittest_ifelse">run</a>)
%   unittest_ifelse
%
% See also IFELSE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'ifelse' );

assert_equals( ifelse( true, 1, 2 ), 1, 'true' );
assert_equals( ifelse( false, 1, 2 ), 2, 'false' );
