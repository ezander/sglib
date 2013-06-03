function [theta,U,V]=subspace_angles(A,B)
% SUBSPACE_ANGLES Compute the principal angles between subspaces.
%   THETA=SUBSPACE_ANGLES(A, B) computes the principal angles THETA between
%   subspaces spanned by the matrices A and B. For a definition see [1]
%   section 12.4.3.
%
%   [THETA,U,V]=SUBSPACE_ANGLES(A, B) also computes the principal vectors
%   and returns them in U and V.
%
% References
%   [1] G. Golub and C. F. Van Loan, Matrix Computations, 3rd ed. John
%       Hopkins University Press
%
% Example (<a href="matlab:run_example subspace_angles">run</a>)
%   A = rand(7, 3);
%   B = rand(7, 5);
%   [theta, U, V] = subspace_angles(A, B)
%
% See also SUBSPACE, SUBSPACE_DISTANCE

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


[QA,RA]=qr(A,0); %#ok<NASGU>
[QB,RB]=qr(B,0); %#ok<NASGU>
C=QA'*QB;
if nargout>1
    [Y,S,Z]=svd(C);
    q=min(size(A,2),size(B,2));
    U=QA*Y(:,1:q);
    V=QB*Z(:,1:q);
    s=diag(S);
else
    s=svd(C);
end
% clamp s between 0 and 1
s=max(min(s,1),0);
theta=acos(s);
