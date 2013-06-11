function C=khatriraorev(A,B)
% KHATRIRAOREV Compute the Khatri-Rao product in reverse order.
%   C=KHATRIRAOREV( A, B ), where DIM(A,2)==DIM(B,2), computes the
%   Khatri-Rao product in reverse order, 
%
% Example (<a href="matlab:run_example khatriraorev">run</a>)
%
% See also

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

[M,R]=size(A);
[N,R2]=size(B);
% check R==R2

C=zeros(M*N,R);
for i=1:R
    C(:,i)=kron(B(:,i), A(:,i) );
end
