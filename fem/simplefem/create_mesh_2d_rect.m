function [pos,els]=create_mesh_2d_rect(numrefine)
% CREATE_MESH_2D_RECT Short description of create_mesh_2d_rect.
%   CREATE_MESH_2D_RECT Long description of create_mesh_2d_rect.
%
% Example (<a href="matlab:run_example create_mesh_2d_rect">run</a>)
%
% See also

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

pos=[0, 1, 1, 0; 0, 0, 1, 1];
els=[1,3;2,4;3,1];

if nargin<1
    numrefine=3;
end

for i=1:numrefine
    [pos,els]=refine_mesh(pos,els);
end


