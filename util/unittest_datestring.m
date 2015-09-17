function unittest_datestring
% UNITTEST_DATESTRING Test the DATESTRING function.
%
% Example (<a href="matlab:run_example unittest_datestring">run</a>)
%   unittest_datestring
%
% See also DATESTRING, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'datestring' );

thedate=[1998,3,17,14,23,12.23];

assert_equals( datestring( 'date', thedate ), '1998-03-17-142312', 'def' );
assert_equals( datestring( 'date', thedate, 'incsecs', false ), '1998-03-17-1423', 'nosec' );
assert_equals( datestring( 'date', thedate, 'inctime', false ), '1998-03-17', 'notime' );
assert_equals( datestring( 'date', thedate, 'separator', '_' ), '1998_03_17_142312', 'underscore' );
assert_equals( datestring( 'date', thedate, 'separator', '%', 'inctime', false ), '1998%03%17', 'percent' );

