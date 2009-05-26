function K=tkron( A, B )
% TKRON   Transposed Kronecker tensor product.
%   TKRON(A,B) returns just KRON(B,A), transposing the order of the
%   arguments. The reason for this is that in this order it better matches
%   other variants of tensor products and conversion is simplified. It is
%   recommended that only TKRON be used with SGLIB.
% 
%   Suppose an elementary tensor T is given by {X,Y}, where X an N vector
%   and Y an M vector, and the matrix representation of T is M=X*Y', then
%   M(:)==tkron(X,Y). Then, suppose A is an NxN matrix and B is an MxM
%   matrix. Then TKRON(A,B) is a block matrix where the blocks are
%   multiples of A (which is preferable for consistency if e.g. the blocks
%   represent stiffness matrices.). So this works both
%      tkron(A,B)*tkron(x,y)==tkron(A*x,B*y)
%      kron(A,B)*kron(x,y)==kron(A*x,B*y)
%   but this works only with tkron naturally 
%      tkron(A,B)*reshape(x*y',[],1)==reshape(A*x*(B*y)',[],1)
%   compared to the hard to remember
%      kron(B,A)*reshape(x*y',[],1)==reshape(A*x*(B*y)',[],1)
%   

%
% Example (<a href="matlab:run_example tkron">run</a>)
%   tf = {'true', 'false'};
%   x=rand(8,1);
%   y=rand(10,1);
%   M=x*y';
%   % have to remember the order
%   bool=all( kron(y,x)==M(:) ); disp( tf{2-bool} );
%   % this is the natural order
%   bool=all( tkron(x,y)==M(:) ); disp( tf{2-bool} );
%   A=rand(8);
%   B=rand(10);
%   U=(A*x)*(B*y)';
%   % this is a lot more natural...
%   bool=norm( tkron(A,B)*tkron(x,y)-U(:) )<1e-12; disp( tf{2-bool} );
%   % than
%   bool=norm( kron(B,A)*kron(y,x)-U(:) )<1e-12; disp( tf{2-bool} );
%
% See also KRON

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% Yes, I know that this function does pretty little, however, its purpose
% is not having to remember the correct ordering for the Kronecker product
% all the time
K=kron(B,A);
