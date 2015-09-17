function unittest_ctensor_add
% UNITTEST_CTENSOR_ADD Test the TENSOR functions.
%
% Example (<a href="matlab:run_example unittest_ctensor_add">run</a>)
%    unittest_ctensor_add
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

munit_set_function( 'ctensor_add' );

T1={rand(8,2), rand(10,2)};
T2={rand(8,3), rand(10,3)};
Z=ctensor_add(T1,T2,3);
assert_equals( Z{1}*Z{2}', T1{1}*T1{2}'+3*T2{1}*T2{2}', 'sum' )
assert_equals( size(Z{1}), [8,5], 'size_1' );
assert_equals( size(Z{2}), [10,5], 'size_2' );

T1={rand(8,2), rand(10,2), rand(12,2)};
T2={rand(8,3), rand(10,3), rand(12,3)};
Z=ctensor_add(T1,T2,3);
assert_equals( cellfun('size', Z, 1 ), [8,10,12], 'size_dim1' );
assert_equals( cellfun('size', Z, 2 ), [5,5,5], 'size_dim2' );
