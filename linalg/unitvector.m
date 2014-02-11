function e=unitvector( k, n, sparsevec )
% UNITVECTOR Creates one or more unit vectors.
%   E=UNITVECTOR( K, N ) creates a unit vector of dimension N with a 1 in
%   dimension K. The result is returned in E as a column vector. K can also
%   be a vector, in which case E is a matrix with column vector number i
%   being the unit vector corresponding to K(i).
%   E=UNITVECTOR( K ) or E=UNITVECTOR( K, [] ) assumes that N is maximum values
%   of K.
%   E=UNITVECTOR( K, N, TRUE ) creates a set of sparse unit vectors.
%
%   Note: Surely, this functionality is pretty trivial, however, it is
%   pretty useful in situations where a unit vector is needed in a function
%   call, since you cannot write e.g. EYE(5)(:,3), and creation via the
%   SPARSE function is neither obvious to read not to write (see code for
%   this.)
% e
% Example (<a href="matlab:run_example unitvector">run</a>)
%   fprintf( 'A single unit vector e_3 (transposed) in R^5: ' );
%   disp( unitvector( 3, 5 )' );
%   fprintf( 'Three unit vectors (transposed) in R^5:\n' );
%   disp( unitvector( [1,2,4], 5 )' );
%   fprintf( 'The same as sparse matrix:\n' );
%   disp( unitvector( [1,2,4], 5, true ) );
%
% See also ZEROS, SPARSE, EYE

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin<2 || isempty(n)
    n=max(k);
end
if nargin<3 || isempty(sparsevec)
    sparsevec=false;
end

m=length(k);
if ~sparsevec
    e=zeros(n,m);
    e(sub2ind(size(e),k,1:m))=1;
else
    e=sparse( k, 1:m, ones(m,1), n, m );
end
