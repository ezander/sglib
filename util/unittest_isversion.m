function unittest_isversion
% UNITTEST_ISVERSION Test the ISVERSION function.
%
% Example (<a href="matlab:run_example unittest_isversion">run</a>)
%   unittest_isversion
%
% See also ISVERSION, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'isversion' );

assert_true( islogical( isversion('0.0','100.0') ), 'should have *some* reasonable value', 'logical' );
assert_false( isversion('0.0','1.0'), 'can''t believe that', 'impossible1' );
assert_false( isversion('100.0','101.0'), 'can''t believe that', 'impossible2' );
assert_true( isversion('1.0'), 'need at least', 'needed' );
