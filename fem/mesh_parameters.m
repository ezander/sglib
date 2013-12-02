function [hmin, hmax, hmean, qual]=mesh_parameters( pos, els )
% MESH_PARAMETERS Determine mesh parameters.
%   [HMIN, HMAX, HMEAN]=MESH_PARAMTERS( POS, ELS ) determines certain mesh
%   parameters from the mesh specified by POS and ELS. The parameters
%   computed are the minimum, the maximum and the mean edge length,
%   returned in HMIN, HMAX and HMEAN, respectively.
%
%   [HMIN, HMAX, HMEAN, QUAL]=MESH_PARAMTERS( POS, ELS ) additionally
%   returns a quality parameter for each element. The paramter currently
%   used is the maximum edge length divided by the inradius. This works
%   only for 2D elements.
%
% Todo:
%   Need to take [1] for computing quality of elements into account.
%
% Example (<a href="matlab:run_example mesh_parameters">run</a>)
%   [pos, els] = create_mesh_2d_rect(0);
%   [hmin, hmax, hmean]=mesh_parameters( pos, els )
%
% References:
%   [1] www.cs.berkeley.edu/~jrs/papers/elemtalk.pdf‎
%
% See also 

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% Determine dimensions
d=size(pos,1);
n=size(els,1);
% Extend elements by repeating the first point
els_ex=[els; els(1,:)];
% Map to points and compute edge vectors
pos_ex=reshape( pos(:,els_ex), [d, size(els_ex)]);
edge_vec=pos_ex(:,1:n,:)-pos_ex(:,2:n+1,:);
% Compute length of edge vectors
h=reshape(sqrt(sum(edge_vec.^2,1)), size(els));

% Compute some statistics
hmin=min(h(:));
hmax=max(h(:));
hmean=mean(h(:));

% For 2D compute goodness of triangles
if d==2
    a = h(1,:);
    b = h(2,:);
    c = h(3,:);
    s = 0.5 * (a+b+c);
    A = sqrt(s.*(s-a).*(s-b).*(s-c));
    r_in = sqrt((s-a).*(s-b).*(s-c)./s);
    r_out = 0.25 * a.*b.*c ./ A;
    swallow(r_out);
    qual=max(h,[],1) ./ r_in;
end
