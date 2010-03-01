function unittest_tensor_to_matrix
% UNITTEST_TENSOR_TO_MATRIX Test the TENSOR_TO_MATRIX function.
%
% Example (<a href="matlab:run_example unittest_tensor_to_matrix">run</a>)
%   unittest_tensor_to_matrix
%
% See also TENSOR_TO_MATRIX, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_to_matrix' );

T2={rand(5,3), rand(7,3)};
v=tensor_to_matrix(T2);
assert_equals( v, T2{1}*T2{2}', 'order2' );

u1=rand(5,2); u2=rand(7,2); u3=rand(9,2);
T3={u1, u2, u3};
v=tensor_to_matrix(T3);
v_ex=repmat( reshape( u1(:,1), [5,1,1]), [1,7,9] ).*...
    repmat( reshape( u2(:,1), [1,7,1]), [5,1,9] ).*...
    repmat( reshape( u3(:,1), [1,1,9]), [5,7,1] )+...
    repmat( reshape( u1(:,2), [5,1,1]), [1,7,9] ).*...
    repmat( reshape( u2(:,2), [1,7,1]), [5,1,9] ).*...
    repmat( reshape( u3(:,2), [1,1,9]), [5,7,1] );
assert_equals( v, v_ex, 'order3' );

