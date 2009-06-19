% Hermite polynomials
%   hermite                          - Return the n-th Hermite polynomial.
%   hermite_val                      - Evaluate expansion in Hermite polynomials.
%   hermite_val_multi                - Evaluate expansion in multivariate Hermite polynomials.
%   hermite_triple_product           - Compute expectation of triple products of Hermite polynomials.
%   hermite_triple_fast              - Cached computation of the expectation of triple products of Hermite polynomials.
%   hermite_norm                     - Compute the norm of multivariate Hermite polynomials.
%
% Multiindices
%   multiindex                       - Generate a table of multiindices (block-scheme).
%   multiindex_factorial             - Compute the factorial of a multiindex.
%   multiindex_order                 - Compute the order of a multiindex.
%   multiindex_combine               - Combine multiindices from different sources.
%   multiindex_find                  - Find a multiindex in a list of indices.
%
% Polynomials chaos expansion
%   pce_expand_1d                    - Calculate the PCE expansion in one stochastics dimension.
%   pce_expand_1d_mc                 - Calculate the PCE expansion in one stochastics dimension (MC).
%   pce_moments                      - Calculate the statistical moments of a distribution given as PCE.
%   normalize_pce                    - Transforms a PCE in unnormed Hermite polys into a PCE in
%   pce_covariance                   - Computes the covariance between variables in a PC
%   pce_field_realization            - Compute a realization of a random field given by a
%   pce_transform_multi              - Transform from local univariate to global
%   pce_cdf                          - 
%   pce_pdf                          - 
%
% Experimental PCE routines
%   pce_divide                       - 
%   pce_function                     - 
%   pce_function_polyexp             - 
%   pce_multiply                     - Multiply two PC expanded random variables.
%   pce_sqrt                         - 
%
% Karhunen-Loeve expansion
%   kl_expand                        - Perform Karhunen-Loeve expansion.
%   kl_pce_field_realization         - Compute a realization of a random field given by a
%   pce_to_kl                        - Truncate a pure PCE field into a KL-PCE field.
%   project_pce_on_kl                - Project a spatially PC expanded field into a KL-PCE field.
%
% Random field expansion
%   expand_field_pce_sg              - Compute the PC expansion of a random field according to a paper of Sakamoto and Ghanem.

% Covariances
%   exponential_covariance           - Compute the exponential covariance function.
%   gaussian_covariance              - Compute the convariance function of gaussian.
%   spherical_covariance             - Compute the spherical covariance function.
%   covariance_matrix                - Calculate point covariance matrix.
%   transform_covariance_pce         - Transforms covariance of underlying Gaussian
%
% Solvers
%
% Distributions
%   beta_cdf                         - Cumulative distribution function of the beta distribution.
%   beta_pdf                         - Probability distribution function of the beta distribution.
%   beta_moments                     - Compute moments of the beta distribution.
%   beta_stdnor                      - Transforms standard normal random numbers into beta distributed ones.
%   exponential_cdf                  - Cumulative distribution function of the exponential distribution.
%   exponential_pdf                  - Probability distribution function of the exponential distribution.
%   exponential_moments              - Compute moments of the exponential distribution.
%   exponential_stdnor               - Transforms standard normal random numbers into exponential distributed ones.
%   lognorm_cdf                      - Cumulative distribution function of the lognorm distribution.
%   lognorm_pdf                      - Probability distribution function of the lognorm distribution.
%   lognorm_moments                  - Compute moments of the lognormal distribution.
%   lognorm_stdnor                   - Transforms standard normal random numbers into lognormal distributed ones.
%   normal_cdf                       - Cumulative distribution function of the normal distribution.
%   normal_pdf                       - Probability distribution function of the normal distribution.
%   normal_moments                   - Compute moments of the normal distribution.
%   normal_stdnor                    - Transforms standard normal random numbers into normal distributed ones.
%   uniform_cdf                      - Cumulative distribution function of the uniform distribution.
%   uniform_moments                  - Compute moments of the uniform distribution.
%   uniform_pdf                      - Probability distribution function of the uniform distribution.
%   uniform_stdnor                   - Transforms standard normal random numbers into uniform distributed ones.
%
% Statistics
%   data_moments                     - Compute moments of given data.
%   inv_reg_beta                     - Compute the inverse regularized beta function.
%   kernel_density                   - Kernel density estimation for given data.
%   empirical_density                - Probability density estimation for given data.
%   ks_test                          - Perform the Kolmogorov-Smirnov test on the samples distribution.
%   randn_sorted                     - Generate sorted, normally distributed numbers from the inverse CDF.
%
% Integration rules
%   gauss_hermite                    - Numerically integrate with Gauss-Hermite quadrature rule.
%   gauss_hermite_multi              - Perform multidimensional Gauss-Hermite quadrature.
%   gauss_hermite_rule               - Return the Gauss-Hermite quadrature rule with p nodes.
%   gauss_legendre_rule              - Get Gauss points and weights for quadrature over [-1,1].
%   clenshaw_curtis_legendre_rule    - quad1d_cc_legendre - nodes and weights of clenshaw-curtis formula
%   full_tensor_grid                 - Return nodes and weights for full tensor product grid.
%   smolyak_grid                     - Return nodes weights for Smolyak quadrature.
%   tensor_mesh                      - Create D-dimensional tensor-product from 1D meshes and weights.
%
% Miscellaneous numerical routines
%   cross_correlation                - Compute cross correlation coefficient between functions.
%   gram_schmidt                     - Perform Gram-Schmidt orthogonalization.
%   revkron                          - Reversed Kronecker tensor product.
%   solver_message                   - 
%
% Stochastic Galerkin method
%   stochastic_operator_kl_pce       - 
%   stochastic_operator_pce          - 
%   stochastic_pce_rhs               - 
%   stochastic_pce_matrix            - Compute the matrix that represents multiplication in the Hermite algebra.
%
% Tensor routines
%   tensor_add                       - Add two sparse tensor products.
%   tensor_apply                     - Apply a tensor operator to a sparse tensor products.
%   tensor_apply_kl_operator         - Apply a KL operator to a sparse tensor product.
%   tensor_norm                      - Compute the norm of a sparse tensor.
%   tensor_null                      - Create a sparse null tensor with correct dimensions.
%   tensor_truncate                    - Computes a truncated rank tensor product.
%   tensor_scalar_product            - Compute the scalar product of two sparse tensors.
%   tensor_scale                     - Scale a sparse tensor product by a scalar.
%   tensor_to_kl                     - Unpack a KL expansion from a tensor product.
%   kl_to_tensor                     - Pack a KL expansion into tensor product format.
%
% Tensor and linear operator routines
%   linear_operator                  - Creates  a linear operator structure from a matrix.
%   linear_operator_apply            - APPLY_LINEAR_OPERATOR Apply a linear operator or matrix to a vector.
%   linear_operator_compose          - Return the composition of two linear operators.
%   linear_operator_size             - Return the size of a linear operator.
%   linear_operator_solve            - Example (<a href="matlab:run_example linear_operator_solve">run</a>)
%   tensor_operator_apply            - APPLY_TENSOR_OPERATOR Apply a tensor operator to a tensor.
%   tensor_operator_compose          - Return the composition of two tensor operators.
%   tensor_operator_size             - Elmar Zander
%   tensor_operator_solve_elementary - Solves an equation with an elementary tensor operator.
%   tensor_operator_solve_jacobi     - 
%
% Miscellaneous system routines
%   startup                          - Set parameters/paths for the programs to run correctly.
%   add_sglib_path                   - Set paths for sglib.
%   isnativesglib                    - Return whether native sglib functions are used.
%
% Test and demo functions/scripts
%   testsuite                        - Run all unit tests in this directory.
%   test_pce_expand_1d               - Test the univariate PCE expansion 
%   test_multiindex                  - Test multi-index related functions.
%   test_moments                     - Test the moment computing functions.
%   test_hermite_triples             - Test the HERMITE_TRIPLE_PRODUCT and HERMITE_TRIPLE_FAST functions.
%   test_gauss_legendre              - Test the Gauss-Legendere quadrature methods.
%   test_gauss_hermite               - Test the Gauss-Hermite quadrature rules.
%   test_distributions               - Test the distribution functions.
%   test_covariance                  - Test covariance related functions.
%   test_inv_reg_beta                - Test the inverse regularized beta function.
%   test_normalize_pce               - Test the normalize_pce function.
%   test_pce_moments                 - Test the PCE_MOMENTS function.
%   test_exponential_covariance      - Test exponential_covariance functions.
%   test_gaussian_covariance         - Test gaussian_covariance functions.
%   test_hermite                     - Test the HERMITE function.
%   test_hermite_val                 - Test the HERMITE_VAL function.
%   test_hermite_val_multi           - Test the hermite_val_multi function.
%   test_utils                       - Test utils related functions.
%   test_cross_correlation           - Test the CROSS_CORRELATION function.
%   test_gram_schmidt                - Test the GRAM_SCHMIDT function
%   test_kl_expand                   - Test the KL_EXPAND function.
%   test_kl_tensor                   - Test the KL_TO_TENSOR and TENSOR_TO_KL functions.
%   test_linear_operator             - Test the LINEAR_OPERATOR and related functions.
%   test_pce_divide                  - Test the PCE_DIVIDE function.
%   test_pce_multiply                - Test the PCE_MULTIPLY function.
%   test_pce_to_kl                   - Test pce_to_kl function.
%   test_stochastic_pce_matrix       - Test the stochastic_pce_matrix function.
%   test_tensor_methods              - Test the TENSOR functions.
%   test_tensor_operator_apply       - Test the TENSOR_OPERATOR_APPLY function.
%   test_tensor_operator_compose     - Test the TENSOR_OPERATOR_COMPOSE function.
%   test_tensor_truncate               - Test the TENSOR_TRUNCATE function.
%   test_tkron                       - TEST_REVKRON Test the REVKRON and function.

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
