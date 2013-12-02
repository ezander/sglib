% FEM
% ===
%
% This folder contains files for working with meshes (nodes, edges,
% boundaries, etc...) for the stochastic Galerkin method. Implementations
% for computing mass and stiffness matrices are contained in subfolders. 
% 
% Most functions require that an array with the position of the nodes (POS)
% and or and array with the node indices of the elements (ELS) are passed
% to them. If the spatial dimension is D and there are N nodes and T
% elements, POS has dimension DxPOS and ELS has dimension (D+1)xT. If a
% function on the nodes is specified it needs to have dimension POSx1, or
% if there are K instances that need to be processed at once it needs to
% have dimension POSxK.
%
% Files
%   clear_non_boundary_values          - Clears all values that don't belong to the boundary.
%   correct_mesh                       - Corrects the orientation of the elements of a 2D mesh.
%   find_boundary                      - Determins the boundary nodes in 1D and 2D meshes.
%   mesh_parameters                    - Determine mesh parameters.
%   point_projector                    - Compute a projection matrix.
%   refine_mesh                        - Refine a finite element mesh.
%
% Unittests
%   unittest_clear_non_boundary_values - Test the CLEAR_NON_BOUNDARY_VALUES function.
%   unittest_correct_mesh              - Test the CORRECT_MESH function.
%   unittest_find_boundary             - Test the FIND_BOUNDARY function.
%   unittest_mesh_parameters           - Test the MESH_PARAMETERS function.
%   unittest_point_projector           - Test the POINT_PROJECTOR function.
%   unittest_refine_mesh               - Test the REFINE_MESH function.

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
