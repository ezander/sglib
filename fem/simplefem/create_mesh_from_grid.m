function [pos, els]=create_mesh_from_grid(X, Y)
% CREATE_MESH_FROM_GRID Creates mesh data structures from a structured grid.
%   [POS, ELS]=CREATE_MESH_FROM_GRID(X, Y) given a structured grid in X and
%   Y, mesh data structures are returned in POS and ELS, consisting of
%   positions in POS and triangular elements in ELS. The grid can be
%   specified in three different ways:
%     1) X and Y are matrices of the same size NX x NY, where X contains
%        the NX x NY x-coordinates and Y contains the respective
%        y-coordinates. Each element of the grid is given by coordinates
%        Z1=(X(i,j),Y(i,j), Z2=(X(i+1,j),Y(i+1,j),
%        Z3=(X(i,j+1),Y(i,j+1) and Z4=(X(i+1,j+1),Y(i+1,j+1) from which two
%        triangles (Z1,Z2,Z3) and (Z2,Z4,Z3) are formed. The coordinates in
%        X and Y do not have to form a square grid, but should not be
%        degenerate. The ordering of nodes in POS is the same as in X(:)
%        and Y(:).
%     2) X and Y are vectors, of possibly different sizes NX and NY
%        respectively. The result is the as if matrices repmat(X, 1, NY) and
%        repmat(Y', NX, 1) were specified (or simpler [MX,MY]=meshgrid(X,Y)).
%     3) X and Y are scalars and integer. The result is the same as if two
%        vectors 1:X and 1:Y were specified.
%
% Example 1 (<a href="matlab:run_example create_mesh_from_grid 1">run</a>)
%     x = linspace(2,6,20);
%     y = linspace(-2,2,30);
%     [pos,els] = create_mesh_from_grid(x,y);
%     z = sin(pos(1,:)) .* cos(pos(2,:));
%     plot_field(pos, els, z');
%
% Example 2 (<a href="matlab:run_example create_mesh_from_grid 2">run</a>)
%     [R, PHI] = meshgrid(linspace(1,2,10), linspace(pi/4,3*pi/4,30));
%     X = R .* cos(PHI); Y = R .* sin(PHI);
%     Z = sin(X) .* cos(Y);
%     [pos,els] = create_mesh_from_grid(X,Y);
%     subplot(2,1,1); surf(X, Y, Z); view(2); axis equal;
%     subplot(2,1,2); plot_field(pos, els, Z(:)); axis equal;
%
% See also

%   Elmar Zander
%   Copyright 2016, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isscalar(X)
    assert(isscalar(Y));
    nx = X;
    ny = Y;
    x = (1:nx)';
    y = (1:ny)';
    [pos, els] = from_vectors(x, y);
elseif isvector(X)
    assert(isvector(Y));
    [pos, els] = from_vectors(X(:), Y(:));
elseif ismatrix(X)
    assert(ismatrix(Y));
    [pos, els] = from_matrices(X, Y);
else
    error('sglib:create_mesh_from_grid', 'Malformed input');
end


function [pos, els]=from_vectors(x, y)
% FROM_VECTOR Create POS, ELS from vectors

[X, Y] = meshgrid(x, y);
[pos, els] = from_matrices(X, Y);


function [pos, els]=from_matrices(X, Y)
% FROM_MATRIX Create POS, ELS from matrices

[ni, nj] = size(X);
assert(size(Y,1)==ni);
assert(size(Y,2)==nj);

% Generate index pairs (i,j)
[i, j] = meshgrid(1:ni-1, 1:nj-1);
% Generate linear index k from index tuples (i,j)
k = sub2ind([ni,nj], i(:), j(:));
% Generate elements structure ELS from linear indices 
els = [k, k+ni, k+1; k+ni, k+ni+1, k+1]';
% Generate node structure POS
pos = [X(:), Y(:)]';
