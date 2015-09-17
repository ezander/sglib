function unittest_tensor_multiply
% UNITTEST_TENSOR_MULTIPLY Test the TENSOR_MULTIPLY function.
%
% Example (<a href="matlab:run_example unittest_tensor_multiply">run</a>)
%   unittest_tensor_multiply
%
% See also TENSOR_MULTIPLY, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

X=rand(3,4,5);
Y=rand(6,4,3);

Z=tensor_multiply( X, Y );
assert_equals( size(Z), [3,4,5,6,4,3], 'size1' );

assert_equals( Z(1,1,1,1,1,1), X(1,1,1)*Y(1,1,1), '111111' );
assert_equals( Z(1,2,3,3,1,3), X(1,2,3)*Y(3,1,3), '123313' );
assert_equals( Z(3,4,5,6,4,3), X(3,4,5)*Y(6,4,3), '345643' );

Z=tensor_multiply( X, Y, 1, 3 );
assert_equals( size(Z), [4,5,6,4], 'size2' );
assert_equals( Z(1,1,1,1), sum(X(:,1,1).*squeeze(Y(1,1,:))), '1111' );
assert_equals( Z(1,2,3,4), sum(X(:,1,2).*squeeze(Y(3,4,:))), '1234' );
assert_equals( Z(4,5,6,4), sum(X(:,4,5).*squeeze(Y(6,4,:))), '4564' );

Z=tensor_multiply( X, Y, 2, 2 );
assert_equals( size(Z), [3,5,6,3], 'size3' );
assert_equals( Z(1,1,1,1), sum(X(1,:,1).*Y(1,:,1)), '1111' );
assert_equals( Z(2,4,5,3), sum(X(2,:,4).*Y(5,:,3)), '1234' );
assert_equals( Z(3,5,6,3), sum(X(3,:,5).*Y(6,:,3)), '4564' );


X=rand(10,12);
Y=rand(12,13);
assert_equals( tensor_multiply( X, Y, 2, 1 ), X*Y, 'XY' );
assert_equals( tensor_multiply( X, Y', 2, 2 ), X*Y, 'XYt' );
assert_equals( tensor_multiply( X', Y, 1, 1 ), X*Y, 'XtY' );
assert_equals( tensor_multiply( X', Y', 1, 2 ), X*Y, 'XtYt' );

% the following is correct; result must be shape (2,3,1) since dimensions of
% Y are appended, not (2,1,3) as I at one time erroneously thought; its
% left in as a reminder
X=ones(2,2,3);
Y=ones(1,2);
Z=2*ones( 2, 3, 1 );
assert_equals( Z, tensor_multiply( X, Y, 2, 2 ), 'singdim' );


% multiple contractions
X=rand(2,3,4);
Y=rand(5,2,3,2);
Z=tensor_multiply( X, Y, [2 1], [3 2] );
assert_equals( size(Z), [4,5,2], 'multcont' );


X=[1 2; 3 4];
Y=[5 6; 7 8];
Z=tensor_multiply( X, Y, [1 2], [1 2] );
assert_equals( Z, 70, 'multcont_1' );
Z=tensor_multiply( X, Y, [2 1], [2 1] );
assert_equals( Z, 70, 'multcont_2' );

Z=tensor_multiply( X, Y, [1 2], [2 1] );
assert_equals( Z, 69, 'multcont_3' );
Z=tensor_multiply( X, Y, [2 1], [1 2] );
assert_equals( Z, 69, 'multcont_4' );


A=ones(2,3,4);
B=ones(3,4);
C=tensor_multiply( A, B, [2 3], [1 2] );
assert_equals( C, [12; 12], 'mult_res_vector');
C=tensor_multiply( A, B, 2, 1 );
assert_equals( C, 3*ones(2,4,4), 'mult_res_tensor');
C=tensor_multiply( A, B, 3, 2 );
assert_equals( C, 4*ones(2,3,3), 'mult_res_tensor2');
