function R=cross_correlation( a, b, M )
% CROSS_CORRELATION Compute cross correlation coefficient between functions.
%   R=CROSS_CORRELATION( A, B ) compute the cross correlation coefficient of
%   the functions (vectors) given in A with those of B, i.e. R(i,j)
%   contains the cross correlation between A(:,i) and B(:,j). As indicated
%   already the function in A and B have to be represented by row vectors.
%   If the function is called as R=CROSS_CORRELATION( A, B, M ) the scalar
%   product used as basis for the calculation is taken to be <x,y>=x'My.
%
% Example (<a href="matlab:run_example cross_correlation">run</a>)
%   disp(cross_correlation( [[1;0;0] [1;1;1]], [ [0;2;0] [3;0;0]]));
%   disp('same as');
%   disp([0 1; 1/sqrt(3) 1/sqrt(3)])
%
% See also

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


%TODO: optionally subtract mean, i.e. compute cross-covariance

if nargin>2 && ~isempty(M)
    R=row_col_mult( a, 1./sqrt(diag(a'*M*a)') )'*M*row_col_mult( b, 1./sqrt(diag(b'*M*b)') );
else
    R=row_col_mult( a, 1./sqrt(sum(a.^2,1)) )'*row_col_mult( b, 1./sqrt(sum(b.^2,1)) );
end
