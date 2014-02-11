function K=revkron( A, B )
% REVKRON   Reversed Kronecker tensor product.
%   REVKRON(A,B) returns just KRON(B,A), reversing the order of the
%   arguments. The reason for this is that in this order it better matches
%   other variants of tensor products and conversion is simplified. It is
%   recommended that only REVKRON be used with SGLIB.
%
%   REVKRON(A) where A is a cell array assumes that A is a tensor product
%   operator and A is of size Rx2, i.e. A={ A_11, A_12; ...; A_R1, A_R2},
%   returns the sum of the reversed Kronecker products of A{i,1} and
%   A{i,2} for i=1:R.
%
% Rational
%   Suppose an elementary tensor T is given by {X,Y}, where X an N vector
%   and Y an M vector, and the matrix representation of T is M=X*Y', then
%   M(:)==revkron(X,Y). Then, suppose A is an NxN matrix and B is an MxM
%   matrix. Then REVKRON(A,B) is a block matrix where the blocks are
%   multiples of A (which is preferable for consistency if e.g. the blocks
%   represent stiffness matrices.). So this works both
%      revkron(A,B)*revkron(x,y)==revkron(A*x,B*y)
%      kron(A,B)*kron(x,y)==kron(A*x,B*y)
%   but this works only with revkron naturally
%      revkron(A,B)*reshape(x*y',[],1)==reshape(A*x*(B*y)',[],1)
%   compared to the hard to remember
%      kron(B,A)*reshape(x*y',[],1)==reshape(A*x*(B*y)',[],1)
%
% Example (<a href="matlab:run_example revkron">run</a>)
%   tf = {'true', 'false'};
%   x=rand(8,1);
%   y=rand(10,1);
%   M=x*y';
%   % have to remember the order
%   bool=all( kron(y,x)==M(:) ); disp( tf{2-bool} );
%   % this is the natural order
%   bool=all( revkron(x,y)==M(:) ); disp( tf{2-bool} );
%   A=rand(8);
%   B=rand(10);
%   U=(A*x)*(B*y)';
%   % this is a lot more natural...
%   bool=norm( revkron(A,B)*revkron(x,y)-U(:) )<1e-12; disp( tf{2-bool} );
%   % than
%   bool=norm( kron(B,A)*kron(y,x)-U(:) )<1e-12; disp( tf{2-bool} );
%
% See also KRON

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

if nargin<2 && iscell( A )
    warning( 'revrkon:deprecated', 'revkron: use in this form is deprecated. use tensor_operator_to_matrix instead' );
    K=kron( A{1,2}, A{1,1} );
    for i=2:size(A,1)
        K=K+kron( A{i,2}, A{i,1} );
    end
else
    K=kron(B,A);
end
