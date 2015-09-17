function M = tridiagonal( N, d, u, l, varargin )
% TRIDIAGONAL Create tridiagonal matrix
%   M = TRIDIAGONAL( N, D, U, L ) creates a tridiagonal matrix with N rows 
%   and columns. D is used as the diagonal value, U for the values on the
%   super- and L for the values on the sub-diagonal. D, U, and L can be
%   scalars or vectors of size N for D or N-1 for U and L.
%
% Example (<a href="matlab:run_example tridiagonal">run</a>)
%   tridiagonal(5, -1, 2, -1)
%
% See also DIAG, MATRIX_GALLERY

%   Elmar Zander
%   Copyright 2002-2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin, mfilename);
[sparsemat,options]=get_option(options, 'sparse', false);
check_unsupported_options(options);

if sparsemat
    i = [1:N, 1:N-1, 2:N];
    j = [1:N, 2:N, 1:N-1];
    v = zeros(1, 3*N-2);
    v(1:N) = d;
    v(N+1:2*N-1) = u;
    v(2*N:3*N-2) = l;
    M=sparse(i,j,v,N,N);
else
    M = zeros( N, N );
    M(1:N+1:end)=d;
    M(2:N+1:end)=l;
    M(N+1:N+1:end)=u;
end