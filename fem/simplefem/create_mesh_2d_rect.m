function [pos,els]=create_mesh_2d_rect(numrefine)
% CREATE_MESH_2D_RECT Creates a mesh of the unitsquare.
%   [POS,ELS]=CREATE_MESH_2D_RECT(NUMREFINE) creates a mesh of the the unit
%   square [0,1]x[0,1] with NUMREFINE global refinements. The final mesh
%   contains 2*(2^NUMREFINE)^2 elements returned in ELS and
%   (2^NUMREFINE+1)^2 nodes returned in POS.
%
% Example (<a href="matlab:run_example create_mesh_2d_rect">run</a>)
%   clf;
%   for i = 1:4
%      subplot(2,2,i);
%      [pos,els]=create_mesh_2d_rect(i);
%      plot_mesh(pos, els);
%   end
%
% See also REFINE_MESH, FIND_BOUNDARY, PLOT_MESH

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

pos=[0, 1, 1, 0; 
     0, 0, 1, 1];
 
els=[1,3;
     2,4;
     3,1];

if nargin<1
    numrefine=3;
end

for i=1:numrefine
    [pos,els]=refine_mesh(pos,els);
end


