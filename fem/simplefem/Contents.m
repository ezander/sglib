% SIMPLEFEM
% =========
%
% This directory contains functions to setup and solve small FEM problems.
% This is really basic and only meant as a small and lightweight support
% for testing the stochastic Galerkin methods, without the need to install
% and call external frameworks. 
%
% PDE and mesh methods
%   create_mesh_2d_rect          - Creates a mesh of the unitsquare.
%   create_mesh_1d               - Creates a 1D mesh for simple finite element calculations.
%   mass_matrix                  - Assemble the mass matrix.
%   stiffness_matrix             - Assemble stiffness matrix for P1 elements.
%
% Unittests
%   unittest_create_mesh_1d      - Test the CREATE_MESH_1D function.
%   unittest_create_mesh_2d_rect - Test the CREATE_MESH_2D_RECT function.
%   unittest_mass_matrix         - Test the MASS_MATRIX function.
%   unittest_stiffness_matrix    - Test the STIFFNESS_MATRIX function.

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
