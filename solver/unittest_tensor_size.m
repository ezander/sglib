function unittest_tensor_size
% UNITTEST_TENSOR_SIZE Test the TENSOR_SIZE function.
%
% Example (<a href="matlab:run_example unittest_tensor_size">run</a>)
%   unittest_tensor_size
%
% See also TENSOR_SIZE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'tensor_size' );

T=rand(3,4,5);
assert_equals( tensor_size(T), [3,4,5], 'full' )


T={rand(8,2), rand(10,2)};
assert_equals( tensor_size(T), [8,10], 'canonical2' );
T={rand(8,3), rand(10,3), rand(12,3)};
assert_equals( tensor_size(T), [8,10,12], 'canonical3' );

assert_error( 'tensor_size(''foo'')', '.*param.*', 'wrong_arg' );
