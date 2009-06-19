% SIMPLEFEM
% =========
%
% This directory contains functions to setup and solve small FEM problems.
% This is really basic and fragmentary and only meant as a small and easy
% support for testing the stochastic Galerkin methods, without the hassle
% of calling external frameworks. 
%
% PDE and mesh methods
%   correct_mesh                 - 
%   refine_mesh                  - 
%   mass_matrix                  - Assemble the mass matrix.
%   stiffness_matrix             - Assemble stiffness matrix for linear tri/tet elements.
%   gauss_legendre_triangle_rule - Get Gauss points and weights for quadrature over canonical triangle.


% PLEASE KEEP THE EMPTY LINE ABOVE SO THAT THE TEST FUNCTIONS DONT CLUTTER
% UP THE CONTENTS DISPLAY.
% Test functions
%   test_boundary_projectors     - Test the boundary_projectors function.
%   test_mass_matrix             - Test the mass_matrix function.
%   test_stiffness               - Test the stiffness_matrix function.



%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.
%   create_mesh_1d               - Creates a 1D mesh for simple finite element calculations.
%   load_pdetool_geom            - 
