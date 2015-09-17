function C=khatriraorev(A,B)
% KHATRIRAOREV Compute the reverse Khatri-Rao product.
%   C=KHATRIRAOREV( A, B ), where DIM(A,2)==DIM(B,2), computes the reverse
%   Khatri-Rao product. The Khatri-Rao product of two matrices A and B of
%   size MxR and NxR is a matrix of size (MN)xR, in which the i-th column
%   is the Kronecker product of the i-th columns of A and B. In this method
%   the reverse Kronecker product instead of the normal Kronecker product
%   is used.
%
% Example (<a href="matlab:run_example khatriraorev">run</a>)
%   A=rand(2,5);
%   B=rand(3,5);
%   khatriraorev(A, B)
%
% See also REVKRON, KRON

%   Elmar Zander
%   Copyright 2010-2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

[M,R]=size(A);
[N,R2]=size(B);
if R~=R2
    error('sglib:khatriraorev', 'Second dimension must be the same for the Khatri-Rao product');
end

C=binfun(@times, reshape(A, [M, 1, R]), reshape(B, [1, N, R]));
C=reshape(C, M*N, R);

% Following is the previous more intuitive, but slower version of this code
% C=zeros(M*N,R);
% for i=1:R
%     C(:,i)=revkron(A(:,i), B(:,i) );
% end
