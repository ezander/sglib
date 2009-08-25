% SGLIB MAIN
% ==========
%
% This directory contains the essential methods for working with stochastic
% Galerkin methods i.e. dealing with stochastic distributions, orthogonal
% polynomials, random field creation, stochastic expansion methods etc.
% Helper functions can be found in the UTIL subdirectory, a unit testing
% framework in MUNIT, plotting functions in PLOT and some methods for
% simple fem computations in SIMPLEFEM (only meant for testing, not for
% real fem computations, where some decent fem software should be called
% from here).
%
% Hermite polynomials
%   hermite                            - Return the n-th Hermite polynomial.
%   hermite_val                        - Evaluate expansion in Hermite polynomials.
%   hermite_val_multi                  - Evaluate expansion in multivariate Hermite polynomials.
%   hermite_triple_product             - Compute expectation of triple products of Hermite polynomials.
%   hermite_triple_fast                - Cached computation of the expectation of triple products of Hermite polynomials.
%   hermite_norm                       - Compute the norm of multivariate Hermite polynomials.
%
% Multiindices
%   multiindex                         - Generate a table of multiindices.
%   multiindex_factorial               - Compute the factorial of a multiindex.
%   multiindex_order                   - Compute the order of a multiindex.
%   multiindex_combine                 - Combine multiindices from different sources.
%   multiindex_find                    - Find a multiindex in a list of indices.
%
% Polynomials chaos expansion
%   pce_expand_1d                      - Calculate the PCE expansion in one stochastics dimension.
%   pce_expand_1d_mc                   - Calculate the PCE expansion in one stochastics dimension (MC).
%   pce_moments                        - Calculate the statistical moments of a distribution given as PCE.
%   normalize_pce                      - Transforms a PCE in unnormed Hermite polys into a PCE in
%   pce_covariance                     - Computes the covariance between variables in a PC
%   pce_field_realization              - Compute a realization of a random field given by a
%   pce_transform_multi                - Transform from local univariate to global
%
% Karhunen-Loeve expansion
%   kl_expand                          - Perform Karhunen-Loeve expansion.
%   kl_pce_field_realization           - Compute a realization of a random field given by a
%   pce_to_kl                          - Reduce a pure PCE field into a KL-PCE field.
%   project_pce_on_kl                  - Project a spatially PC expanded field into a KL-PCE field.
%
% Random field expansion
%   expand_field_pce_sg                - Compute the PC expansion of a random field according to a paper of Sakamoto and Ghanem.
%
% Covariances
%   exponential_covariance             - Compute the exponential covariance function.
%   gaussian_covariance                - Compute the convariance function of gaussian.
%   spherical_covariance               - Compute the spherical covariance function.
%   covariance_matrix                  - Calculate point covariance matrix.
%   transform_covariance_pce           - Transforms covariance of underlying Gaussian
%
% Distributions
%   beta_cdf                           - Cumulative distribution function of the beta distribution.
%   beta_pdf                           - Probability distribution function of the beta distribution.
%   beta_moments                       - Compute moments of the beta distribution.
%   beta_stdnor                        - Transforms standard normal random numbers into beta distributed ones.
%   exponential_cdf                    - Cumulative distribution function of the exponential distribution.
%   exponential_pdf                    - Probability distribution function of the exponential distribution.
%   exponential_moments                - Compute moments of the exponential distribution.
%   exponential_stdnor                 - Transforms standard normal random numbers into exponential distributed ones.
%   lognormal_cdf                      - Cumulative distribution function of the lognormal distribution.
%   lognormal_pdf                      - Probability distribution function of the lognormal distribution.
%   lognormal_moments                  - Compute moments of the lognormal distribution.
%   lognormal_stdnor                   - Transforms standard normal random numbers into lognormal distributed ones.
%   normal_cdf                         - Cumulative distribution function of the normal distribution.
%   normal_pdf                         - Probability distribution function of the normal distribution.
%   normal_moments                     - Compute moments of the normal distribution.
%   normal_stdnor                      - Transforms standard normal random numbers into normal distributed ones.
%   uniform_cdf                        - Cumulative distribution function of the uniform distribution.
%   uniform_moments                    - Compute moments of the uniform distribution.
%   uniform_pdf                        - Probability distribution function of the uniform distribution.
%   uniform_stdnor                     - Transforms standard normal random numbers into uniform distributed ones.
%
% Statistics
%   data_moments                       - Compute moments of given data.

%   kernel_density                     - Kernel density estimation for given data.
%   empirical_density                  - Probability density estimation for given data.
%   ks_test                            - Perform the Kolmogorov-Smirnov test on the samples distribution.

%
% Integration rules
%   gauss_hermite                      - Numerically integrate with Gauss-Hermite quadrature rule.
%   gauss_hermite_multi                - Perform multidimensional Gauss-Hermite quadrature.
%   gauss_hermite_rule                 - Return the Gauss-Hermite quadrature rule with p nodes.
%   gauss_legendre_rule                - Get Gauss points and weights for quadrature over [-1,1].
%   clenshaw_curtis_legendre_rule      - quad1d_cc_legendre - nodes and weights of clenshaw-curtis formula
%   full_tensor_grid                   - Return nodes and weights for full tensor product grid.
%   smolyak_grid                       - Return nodes weights for Smolyak quadrature.
%   tensor_mesh                        - Create D-dimensional tensor-product from 1D meshes and weights.
%
% Miscellaneous numerical routines
%   cross_correlation                  - Compute cross correlation coefficient between functions.
%   gram_schmidt                       - Perform Gram-Schmidt orthogonalization.
%   solver_message                     - 
%
% Stochastic Galerkin method
%   compute_kl_pce_operator            - 
%   compute_pce_operator               - 
%   compute_pce_matrix                 - Compute the matrix that represents multiplication in the Hermite algebra.
%   compute_pce_rhs                    - Compute the right hand side in a linear equation involving the PCE.
%
% Application of boundary conditions to tensors and tensor operators
%   boundary_projectors                - Projection matrices on the set of inner and boundary nodes.
%   apply_boundary_conditions_operator - Apply essential boundary conditions to operator.
%   apply_boundary_conditions_rhs      - Apply essential boundary conditions to right hand side.
%   apply_boundary_conditions_solution - Applies boundary conditions to the solution.
%
% Tensor and linear operator routines
%   linear_operator                    - Creates  a linear operator structure from a matrix.
%   linear_operator_apply              - Apply a linear operator or matrix to a vector.
%   linear_operator_compose            - Return the composition of two linear operators.
%   linear_operator_size               - Return the size of a linear operator.
%   linear_operator_solve              - Solve a linear equation for a general linear operator.
%
% Miscellaneous system routines
%   sglib_addpath                      - Set paths for sglib.
%   sglib_check_setup                  - Checks whether SGLIB was setup correctly.
%   sglib_get_appdata                  - Retrieves SGLib application specific data.
%   sglib_help                         - Show SGLIB help overview.
%   sglib_set_appdata                  - Stores SGLib application specific data.
%   sglib_settings                     - before running the setup should have been performed at least partly
%   sglib_startup                      - Called automatically by Matlab at startup.
%   startup                            - Called automatically by Matlab at startup.

%


% PLEASE KEEP THE EMPTY LINE ABOVE SO THAT THE TEST FUNCTIONS DONT CLUTTER
% UP THE CONTENTS DISPLAY.
% Test and demo functions/scripts
%   testsuite                          - Run all unit tests in this directory.
%   unittest_apply_boundary_conditions - Test the APPLY_BOUNDARY_CONDITIONS function.
%   unittest_compute_pce_matrix        - Test the compute_pce_matrix function.
%   unittest_covariance                - Test covariance related functions.
%   unittest_cross_correlation         - Test the CROSS_CORRELATION function.
%   unittest_distributions             - Test the distribution functions.
%   unittest_exponential_covariance    - Test EXPONENTIAL_COVARIANCE functions.
%   unittest_gauss_hermite             - Test the Gauss-Hermite quadrature rules.
%   unittest_gauss_legendre            - Test the Gauss-Legendere quadrature methods.
%   unittest_gaussian_covariance       - Test GAUSSIAN_COVARIANCE functions.
%   unittest_gram_schmidt              - Test the GRAM_SCHMIDT function
%   unittest_hermite                   - Test the HERMITE function.
%   unittest_hermite_triples           - Test the HERMITE_TRIPLE_PRODUCT and HERMITE_TRIPLE_FAST functions.
%   unittest_hermite_val               - Test the HERMITE_VAL function.
%   unittest_hermite_val_multi         - Test the hermite_val_multi function.
%   unittest_kl_expand                 - Test the KL_EXPAND function.
%   unittest_linear_operator           - Test the LINEAR_OPERATOR and related functions.
%   unittest_moments                   - Test the moment computing functions.
%   unittest_multiindex                - Test multi-index related functions.
%   unittest_normalize_pce             - Test the normalize_pce function.
%   unittest_pce_expand_1d             - Test the univariate PCE expansion
%   unittest_pce_moments               - Test the PCE_MOMENTS function.
%   unittest_pce_to_kl                 - Test the PCE_TO_KL function.
%   unittest_utils                     - Test utils related functions.


%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


