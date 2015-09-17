function unittest_tensor_null
% UNITTEST_TENSOR_NULL Test the TENSOR_NULL functions.
%
% Example (<a href="matlab:run_example unittest_tensor_null">run</a>)
%    unittest_tensor_null
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007-2014, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_null' );

assert_equals( tensor_null(ones(3,4,5)), zeros(3,4,5), 'full' );

Z=tensor_null({rand(8,3), rand(10,3)});
assert_equals( norm( Z{1}*Z{2}', 'fro' ), 0, 'norm' );
assert_equals( size(Z{1}), [8,0], 'size_1' );
assert_equals( size(Z{2}), [10,0], 'size_2' );

Z=tensor_null({rand(8,3), rand(10,3), rand(12,3)});

assert_equals( cellfun('size', Z, 1 ), [8,10,12], 'size_dim1' );
assert_equals( cellfun('size', Z, 2 ), [0,0,0], 'size_dim2' );

