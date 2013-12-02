% SIMPLEFEM
% =========
%
% This directory contains functions to setup and solve small FEM problems.
% This is really basic and fragmentary and only meant as a small and easy
% support for testing the stochastic Galerkin methods, without the hassle
% of calling external frameworks.
%
% PDE and mesh methods
%   clear_non_boundary_values          - Clears all values that don't belong to the boundary.
%   correct_mesh                       - Corrects the orientation of the elements of a 2D mesh.
%   create_mesh_2d_rect                - Creates a mesh of the unitsquare.
%   create_mesh_1d                     - Creates a 1D mesh for simple finite element calculations.
%   find_boundary                      - Determins the boundary nodes in 1D and 2D meshes.
%   mass_matrix                        - Assemble the mass matrix.
%   mesh_parameters                    - Determine mesh parameters.
%   point_projector                    - Compute a projection matrix.
%   refine_mesh                        - Refine a finite element mesh.
%   stiffness_matrix                   - Assemble stiffness matrix for P1 elements.
%
% Unittests
%   unittest_clear_non_boundary_values - Test the CLEAR_NON_BOUNDARY_VALUES function.
%   unittest_correct_mesh              - Test the CORRECT_MESH function.
%   unittest_create_mesh_1d            - Test the CREATE_MESH_1D function.
%   unittest_create_mesh_2d_rect       - Test the CREATE_MESH_2D_RECT function.
%   unittest_find_boundary             - Test the FIND_BOUNDARY function.
%   unittest_mass_matrix               - Test the MASS_MATRIX function.
%   unittest_mesh_parameters           - Test the MESH_PARAMETERS function.
%   unittest_point_projector           - Test the POINT_PROJECTOR function.
%   unittest_refine_mesh               - Test the REFINE_MESH function.
%   unittest_stiffness_matrix          - Test the STIFFNESS_MATRIX function.

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.
