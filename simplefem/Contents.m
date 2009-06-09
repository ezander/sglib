% PDE and mesh methods
%   correct_mesh                       - 
%   refine_mesh                        - 
%   mass_matrix                        - Assemble the mass matrix.
%   stiffness_matrix                   - Assemble stiffness matrix for linear tri/tet elements.
%   gauss_legendre_triangle_rule       - Get Gauss points and weights for quadrature over canonical triangle.

% Boundary conditions
%   boundary_projectors                - Projection matrices on the set of inner and boundary nodes.
%   apply_boundary_conditions_operator - 
%   apply_boundary_conditions_rhs      - 
%   apply_boundary_conditions_solution - 

% Test functions
%   test_apply_boundary_conditions     - Test the apply_boundary_conditionsfunction.
%   test_boundary_projectors           - Test the boundary_projectors function.
%   test_mass_matrix                   - Test the mass_matrix function.
%   test_stiffness                     - Test the stiffness_matrix function.
