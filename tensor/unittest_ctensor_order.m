function unittest_ctensor_order
% UNITTEST_CTENSOR_ORDER Test the CTENSOR_ORDER function.
%
% Example (<a href="matlab:run_example unittest_ctensor_order">run</a>)
%   unittest_ctensor_order
%
% See also CTENSOR_ORDER, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'ctensor_order' );

T={rand(8,2), rand(10,2)};
assert_equals( ctensor_order(T), 2, 'canonical2' );
T={rand(8,3), rand(10,3), rand(12,3)};
assert_equals( ctensor_order(T), 3, 'canonical3' );

assert_error( 'ctensor_order(rand(3,4))', '.*param.*', 'wrong_arg' );
