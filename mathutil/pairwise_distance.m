function d = pairwise_distance(pos1, pos2, varargin)
% PAIRWISE_DISTANCE Compute all pairwise distances between points.
%   D = PAIRWISE_DISTANCE(POS) computes all pairwise distances between
%   points in POS. Spatial dimensions go into the first dimenesion of pos
%   and point index into the second, i.e. POS(2,3) is the second dimension
%   of point number 3.
%
%   D = PAIRWISE_DISTANCE(POS1, POS2) computes all pairwise distances
%   between points in POS1 and POS2.
%
%   D = PAIRWISE_DISTANCE(POS1, POS2, 'norm', P) computes all pairwise
%   distances between points in POS1 and POS2 in the P-norm, where P can be
%   from 1 to INF inclusively. Default for 'norm' is 2.
%
%
% Example (<a href="matlab:run_example pairwise_distance">run</a>)
%   pos = rand(3, 5); % Create 5 points in 3D
%   d = pairwise_distance(pos, 'norm', inf) % Compute max norm distance
%
% See also NORM

%   Elmar Zander
%   Copyright 2016, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% Note:
%  a) pos(1,:) contains all the x positions, pos(2,:) all the y positions
%     and so on 
%  b) let pos have size (d,N)
%  c) so A=permute(pos, [2,3,1]) creates an order 3 tensor of size (N,1,d)
%     such that the first dimension of A is the second of pos (enumerating
%     the points), the second is singleton (because the third nonexisting
%     dimension of pos was implictly singleton), and the third is of size d 
%     (enumerating the dimensions x, y, ...)
%  d) so B=permute(pos, [3,2,1]) creates an order 3 tensor of size (1,N,d)
%     such that the first dimension of B is singleton, the second is the
%     second of pos (enumerating the points), and the third is of size d
%     (enumerating the dimensions x, y, ...)
%  e) so C=A-B (evaluated by bsxfun to automatically expand singleton
%     dimensions) is a tensor of size (N,N,d) with
%     C(i,j,k)=pos(k,i)-pos(k,j)
%  f) So summing C.^2 over the third dimension gives the distances between
%     the points pos(:,i) and pos(:,j)

if nargin<2 || isempty(pos2)
    pos2 = pos1;
end
if ischar(pos2)
    varargin = [pos2, varargin];
    pos2 = pos1;
end

options = varargin2options(varargin, mfilename);
[p, options] = get_option(options, 'norm', 2);
[w, options] = get_option(options, 'weights', []);
check_unsupported_options(options);

if ~isempty(w)
    pos1 = binfun(@times, pos1, w(:));
    pos2 = binfun(@times, pos2, w(:));
end

C=abs(bsxfun(@minus, permute(pos1, [2,3,1]), permute(pos2, [3,2,1])));
if isinf(p)
    d=max(C,[],3);
else
    % Columnwise scaling (before/after) could be sensible here for very
    % large or very small values to avoid over- and underflow
    d=(sum(C.^p,3)).^(1/p);
end
