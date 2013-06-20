function B=row_col_mult( A, x )
% ROW_COL_MULT Multiply a matrix column- or row-wise with a vector.
%   B=ROW_COL_MULT( A, X ) multiplies the matrix A with the vector X in a
%   row or column wise fashion, depending on the shape of the vector X. If
%   X is a row vector each column of A (i.e. A(:,i)) is multiplied by X(i).
%   If X is a column vector each row of A (i.e. A(i,:)) is multiplied by
%   X(i).
%
%   The implementation is rather trivial, but tests have shown this to be
%   the fastest method in Matlab, so it got implemented as an extra
%   function, which furthermore improves the readability of some codes.
%
% Example (<a href="matlab:run_example row_col_mult">run</a>)
%   A=[1 2; 3 4];
%   row_col_mult(A,[1, 10]) % column-wise mult; prints [1 20; 3 40]
%   row_col_mult(A,[1; 10]) % row-wise mult; prints [1 2; 30 40]
%
% See also TIMES, MTIMES

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% x must be a vector or scalar (isvector checks for both)
if ~isvector(x)
    error('util:row_col_mult:no_vector', 'input argument x is not a vector');
end

if size(x,1)==1
    % row vector
    N=size(x,2);
    if issparse(A)
        B=A*spdiags(x',0,N,N);
    else
        B=full(A*spdiags(x',0,N,N));
    end
else
    % column vector
    N=size(x,1);
    if issparse(A)
        B=spdiags(x,0,N,N)*A;
    else
        B=full(spdiags(x,0,N,N)*A);
    end
end
