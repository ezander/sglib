function unittest_tensor_scale
% UNITTEST_TENSOR_SCALE Test the TENSOR_SCALE functions.
%
% Example (<a href="matlab:run_example unittest_tensor_scale">run</a>)
%    unittest_tensor_scale
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


% testing function TENSOR_SCALE
munit_set_function( 'tensor_scale' );

T=rand(3,4,5);
assert_equals( tensor_scale(T, 5), 5*T, 'scale_full' )

T={rand(8,2), rand(10,2)};
S=tensor_scale(T,-3);
assert_equals( S{1}*S{2}', -3*T{1}*T{2}', 'scale' )

Z=tensor_scale(T,0);
assert_equals( Z{1}*Z{2}', zeros(8,10), 'scale_zero' )
assert_equals( cellfun('size', Z, 2 ), [0,0], 'scale_zero_dim' );

T={rand(8,2), rand(10,2), rand(12,2)};
Z=tensor_scale(T,2);
assert_equals( Z, {2*T{1},T{2},T{3}}, 'scale_ord_three' );

assert_error( 'tensor_scale(struct(),2)', '.*param.*', 'param_err' );


