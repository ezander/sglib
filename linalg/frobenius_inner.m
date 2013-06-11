function d=frobenius_inner(A,B)
% FROBENIUS_INNER Computes the Frobenius inner product.
%   D=FROBENIUS_INNER(A,B) computes the Frobenius inner product between
%   matrices A and B. The Frobenius inner product is given by 
%     A:B := tr(A'*B) = sum_ij A_ij B_ij
%
% Note:
%   The computation is of course not carried out by the trace formula,
%   which is very inefficient, but by a more efficient method. 
%
% Example (<a href="matlab:run_example frobenius_inner">run</a>)
%   A = rand(4,5);
%   B = rand(4,5);
%   fprintf('A:B=%g\n', frobenius_inner(A, B));
%   % computing the Frobenius norm
%   fprintf('||A||_F=%g=%g\n', sqrt(frobenius_inner(A, A)), norm(A,'fro'));
%
% See also NORM, TRACE

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


[r,c,v]=find(A.*B);
swallow(r,c);
d=sum(v);
