function test_apply_tensor_operator
% TEST_APPLY_TENSOR_OPERATOR Test the APPLY_TENSOR_OPERATOR function.
%
% Example 
%    test_apply_tensor_operator
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'apply_tensor_operator' );


% there is not much point in bigger matrices here, just check that basic
% functionality works
M=[1, 2, 4; 3, 4, 6; 5, 10, 20];
x=[1; 5; 4];
y=M*x;
assert_equals( apply_tensor_operator( M, x ), y, 'kron/vect' );

%
%irnd=@(x,y)(round(10*rand(x,y)))
%A=irnd(2,5); B=irnd(4,3); x=irnd(5,1); y=irnd(3,1); 
%kron(A,B)*kron(x,y)==kron(A*x,B*y)
%kron(B,A)*reshape(x*y',[],1)==reshape(A*x*(B*y)',[],1)

R=3; RX=3;
M1=3; N1=4;
M2=2; N2=6;
A=cell(R,2);
Ak=zeros(M1*M2,N1*N2);
Ab=cell(M2,N2);
Alin=cell(R,2);
X={rand(N1,RX), rand(N2,RX)};
Xmat=X{1}*X{2}';
B={zeros(M1,0), zeros(M2,0)};

for i=1:R
    A(i,1:2)={rand(M1,N1), rand(M2,N2) };
    Alin{i,1}={@apply_linear_operator,{A{i,1}}, {1} };
    Alin{i,2}={@apply_linear_operator,{A{i,2}}, {1} };
    
    Ak=Ak+kron( A{i,2}, A{i,1} );
    for j=1:M2
        for k=1:N2
            if isempty(Ab{j,k}); Ab{j,k}=zeros(M1,N1); end
            Ab{j,k}=Ab{j,k}+A{i,2}(j,k)*A{i,1};
        end
    end
    B={[B{1}, A{i,1}*X{1}], [B{2}, A{i,2}*X{2}] };
end
Bmat=B{1}*B{2}';


assert_equals( Ak, cell2mat(Ab), 'internal/AkAb' );
assert_equals( apply_tensor_operator( Ak, Xmat(:) ), Bmat(:), 'kron/vect' );
assert_equals( apply_tensor_operator( Ab, Xmat(:), 'optype', 'block' ), Bmat(:), 'block/vect' );
%assert_equals( apply_tensor_operator( Ab, X, 'optype', 'block' ), Bmat, 'block/tensor' );
assert_equals( apply_tensor_operator( Ab, Xmat, 'optype', 'block' ), Bmat, 'block/mat' );
assert_equals( apply_tensor_operator( A, Xmat ), Bmat, 'tensor/mat' );
assert_equals( apply_tensor_operator( A, X ), B, 'tensor/tensor' );
assert_equals( apply_tensor_operator( Alin, X ), B, 'lin_op_tensor/tensor' );


%assert_equals( apply_tensor_operator( Alin, X, 'reduce', @tensor ), B, 'lin_op_tensor/tensor' );


return





A=[ 1 2; 3 5];
B=[ 1 2 1; 3 2 1; 5 0 10];
C={ A(1,1)*B, A(1,2)*B;  A(2,1)*B, A(2,2)*B;  }
norm(kron(A,B)-cell2mat(C))

1;

