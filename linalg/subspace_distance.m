function dist=subspace_distance(A,B)
% SUBSPACE_DISTANCE Short description of subspace_distance.
%   SUBSPACE_DISTANCE Long description of subspace_distance.
%
% Example (<a href="matlab:run_example subspace_distance">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if ~iscell(A)
    A=orth(A);
    B=orth(B);
    if size(A,2)<size(B,2)
        dist=norm(A-B*B'*A);
    else
        dist=norm(B-A*A'*B);
    end
    % should give the same as the sin(subspace(A1,A2)) where subspace is a
    % matlab buildin for computing angles between subspaces
else
    % A={A1,A2}
    
end
