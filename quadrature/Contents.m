% QUADRATURE
%
% Basic 1D quadrature rules all end in "_rule" and return the nodes as a
% row vector and the weights as a column vector (which is often the other
% way round, but works better with the rest of sglib). The functions ending
% in "_nested" call the basic rule functions such that the nodes of rule
% number N are a subset of those of rule number N+1 (i.e. they are nested
% or embedded). The 1D rules can be used as basic quadrature formulas in
% functions to create high-dimensional integration rules based e.g. on full
% tensor or on Smolyak grids.
%
% Basic 1D Rules
%   clenshaw_curtis_nested                - Compute the nested Clenshaw-Curtis rule.
%   clenshaw_curtis_rule                  - Compute nodes and weights of the Clenshaw-Curtis rules.
%   gauss_hermite_rule                    - Return the Gauss-Hermite quadrature rule with p nodes.
%   gauss_legendre_rule                   - Get Gauss points and weights for quadrature over [-1,1].
%   gauss_legendre_triangle_rule          - Get Gauss points and weights for quadrature over canonical triangle.
%   newton_cotes_rule                     - Compute points and weights of the trapezoidal rule.
%   trapezoidal_nested                    - Computes the nested trapezoidal rule.
%   trapezoidal_rule                      - Compute points and weights of the trapezoidal rule.
%
% Grid generation for high-dimensional quadrature
%   full_tensor_grid                      - Return nodes and weights for full tensor product grid.
%   smolyak_grid                          - Return nodes weights for Smolyak quadrature.
%   tensor_mesh                           - Create D-dimensional tensor-product from 1D meshes and weights.
%
% Easy-to-use integration methods
%   gauss_hermite                         - Numerically integrate with Gauss-Hermite quadrature rule.
%   integrate_1d                          - Integrate a univariate function.
%   integrate_nd                          - Integrate a multivariate function.
%
% Unittests
%   unittest_clenshaw_curtis_rule         - Test the CLENSHAW_CURTIS_RULE function.
%   unittest_full_tensor_grid             - Test the FULL_TENSOR_GRID function.
%   unittest_gauss_hermite                - Test the GAUSS_HERMITE function.
%   unittest_gauss_hermite_rule           - Test the GAUSS_HERMITE_RULE function.
%   unittest_gauss_legendre_rule          - UNITTEST_GAUSS_LEGENDRE Test the Gauss-Legendere quadrature methods.
%   unittest_gauss_legendre_triangle_rule - Test the GAUSS_LEGENDRE_TRIANGLE_RULE function.
%   unittest_integrate_1d                 - Test the INTEGRATE_1D function.
%   unittest_integrate_nd                 - Test the INTEGRATE_ND function.
%   unittest_newton_cotes_rule            - Test the NEWTON_COTES_RULE function.
%   unittest_smolyak_grid                 - Test the SMOLYAK_GRID function.
%   unittest_tensor_mesh                  - Test the TENSOR_MESH function.
%   unittest_trapezoidal_rule             - Test the TRAPEZOIDAL_RULE function.
