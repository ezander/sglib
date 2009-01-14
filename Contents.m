% Hermite polynomials
%   hermite                       - Return the n-th Hermite polynomial.
%   hermite_val                   - Evaluate expansion in Hermite polynomials.
%   hermite_val_multi             - Evaluate expansion in multivariate Hermite polynomials.
%   hermite_triple_product        - Compute expectation of triple products of Hermite polynomials.
%   hermite_triple_fast           - Cached computation of the expectation of triple products of Hermite polynomials.
%   hermite_norm                  - Compute the norm of multivariate Hermite polynomials.
%   sort_triple                   - Sorts an index triple (obsolete). 
% Multiindices
%   multiindex                    - Generate a table of multiindices (block-scheme).
%   multiindex_factorial          - Compute the factorial of a multiindex.
%   multiindex_order              - Compute the order of a multiindex.
% Polynomials chaos expansion
%   pce_expand_1d                 - Calculate the PCE expansion in one stochastics dimension.
%   pce_expand_1d_mc              - Calculate the PCE expansion in one stochastics dimension (MC).
%   pce_expand_2d                 - Calculate the PCE expansion in two stochastics dimensions.
%   pce_moments                   - Calculate the statistical moments of a distribution given as PCE.
%   normalize_pce                 - Transforms a PCE in unnormed Hermite polys into a PCE in
%   pce_covariance                - Computes the covariance between variables in a PC
%   pce_field_realization         - Compute a realization of a random field given by a
%   pce_transform_multi           - Transform from local univariate to global
% Karhunen-Loeve expansion
%   kl_expand                     - Perform Karhunen-Loeve expansion.
%   kl_pce_field_realization      - Compute a realization of a random field given by a
%   pce_to_kl                     - Convert a PC expanded field into a KL-PCE field.
%   project_pce_on_kl             - Project a spatially PC expanded field into a KL-PCE field.
% Random field expansion

%   expand_field_pce_sg           - Compute the PC expansion of a random field according to a paper of Sakamoto and Ghanem.
% Covariances
%   exponential_covariance        - Compute the exponential covariance function.
%   gaussian_covariance           - Compute the convariance function of gaussian.
%   covariance_matrix             - Calculate point covariance matrix.
%   mass_matrix                   - Assemble the mass matrix.
%   transform_covariance_pce      - Transforms covariance of underlying Gaussian
% Solvers
%   solve_mat_decomp              - Solves a linear system using a matrix deomposition method.
% Distributions
%   beta_cdf                      - Cumulative distribution function of the beta distribution.
%   beta_pdf                      - Probability distribution function of the beta distribution.
%   beta_moments                  - Compute moments of the beta distribution.
%   beta_stdnor                   - Transforms standard normal random numbers into beta distributed ones.
%   exponential_cdf               - Cumulative distribution function of the exponential distribution.
%   exponential_pdf               - Probability distribution function of the exponential distribution.
%   exponential_moments           - Compute moments of the exponential distribution.
%   exponential_stdnor            - Transforms standard normal random numbers into exponential distributed ones.
%   lognorm_cdf                   - Cumulative distribution function of the lognorm distribution.
%   lognorm_pdf                   - Probability distribution function of the lognorm distribution.
%   lognorm_moments               - Compute moments of the lognormal distribution.
%   lognorm_stdnor                - Transforms standard normal random numbers into lognormal distributed ones.
%   normal_cdf                    - Cumulative distribution function of the normal distribution.
%   normal_pdf                    - Probability distribution function of the normal distribution.
%   normal_moments                - Compute moments of the normal distribution.
%   normal_stdnor                 - Transforms standard normal random numbers into normal distributed ones.
%   distribution_object           - 
% Statistics
%   data_moments                  - Compute moments of given data.
%   inv_reg_beta                  - Compute the inverse regularized beta function.
%   kernel_density                - Kernel density estimation for given data.
%   empirical_density             - Probability density estimation for given data (experimental).
%   ks_test                       - Perform the Kolmogorov-Smirnov test on the samples distribution.
%   randn_sorted                  - Generate sorted, normally distributed numbers from the inverse CDF.
% Integration rules
%   gauss_hermite                 - Numerically integrate with Gauss-Hermite quadrature rule.
%   gauss_hermite_multi           - Perform multidimensional Gauss-Hermite quadrature.
%   gauss_hermite_rule            - Return the Gauss-Hermite quadrature rule with p nodes.
%   gauss_legendre_rule           - Get Gauss points and weights for quadrature over [-1,1].
%   gauss_legendre_triangle_rule  - Get Gauss points and weights for quadrature over canonical triangle.
% Miscellaneous
%   truncated_svd                 - 
%   stiffness_matrix              - Assemble stiffness matrix for linear tri/tet elements.
%   row_col_mult                  - Multiply a matrix column- or row-wise with a vector.
%   cross_correlation             - Compute cross correlation coefficient between functions.
% Test and demo functions/scripts
%   testsuite                     - Run all unit tests in this directory.
%   test_pce_expand_1d            - Test the univariate PCE expansion 
%   test_multiindex               - Test multi-index related functions.
%   test_moments                  - Test the moment computing functions.

%   test_hermite_triples          - Test the Hermite triple functions.
%   test_gauss_legendre           - Test the Gauss-Legendere quadrature methods.
%   test_gauss_hermite            - Test the Gauss-Hermite quadrature rules.
%   test_distributions            - Test the distribution functions.
%   test_covariance               - Test covariance related functions.
%   test_inv_reg_beta             - Test the inverse regularized beta function.
%   test_normalize_pce            - Test the normalize_pce function.
%   test_pce_moments              - 
%   test_row_col_mult             - 
%   test_solve_mat_decomp         - 
% Demos
%   demo_distributions            - Demonstrate usage and some properties of the probability distribution functions.
%   demo_gauss_hermite            - Calculate integral of monomials with Gaussian weighting function. The
%   demo_hermite_triples          - 
%   demo_kl_expand                - Demonstrate usage of the Karhunen-Loeve expansion functions
%   demo_ks_test                  - Demonstrate the usage of the  Kolmogorov-Smirnov test function.
%   demo_pce_expand_1d            - Test the univariate PCE expansion 
%   demo_pce_structs              - Probably we will need some structs to capture all information on a random
%   demo_rf_expand_pce_sg         - 
%   demo_ssfem_string_1d          - Here we will look at a simple stochastic boundary value problem described
%   paper_sakamoto_ghanem         - Test the ideas in a paper of Sakamoto and Ghanem.
%   paper_phoon                   - Multivariate level incompatibility
%   publish_demos                 - 




%   correct_mesh                  - 
%   demo_animation                - 
%   demo_compare_direct_kl_pce_kl - s=load('mesh/rect_mesh_coarse.mat');
%   demo_covariance_functions     - This demo shows the different covariance functions available.
%   demo_field_expand_2d          - s=load('mesh/rect_mesh_coarse.mat');
%   demo_zinn_harvey              - 
%   multiindex_combine            - 
%   orthpol                       - Section 2.4 of
%   pce_cdf                       - 
%   pce_pdf                       - 
%   plot_field                    - 
%   presentation_oberseminar      - this file generates all the images for the oberseminar
%   presentation_oberseminar_mod  - this file generates all the images for the oberseminar
%   refine_mesh                   - 
%   spherical_covariance          - Compute the spherical covariance function.
%   stochastic_pce_matrix         - 
%   test_exponential_covariance   - Test exponential_covariance functions.
%   test_gaussian_covariance      - Test gaussian_covariance functions.
%   test_hermite                  - 
%   test_hermite_val              - Test the HERMITE_VAL function.
%   test_hermite_val_multi        - 
%   test_mass_matrix              - Test the mass_matrix function.
%   test_stiffness                - TEST_stiffness_MATRIX Test the stiffness_matrix function.
%   test_utils                    - 
%   testing_bimodal               - 
%   uniform_cdf                   - Cumulative distribution function of the uniform distribution.
%   uniform_moments               - Compute moments of the uniform distribution.
%   uniform_pdf                   - Probability distribution function of the uniform distribution.
%   uniform_stdnor                - Transforms standard normal random numbers into uniform distributed ones.
%   zinn_harvey_connected_stdnor  - Transforms standard normal random numbers with the Zinn Harvey transform.



% Common variable names
%   It was aspired to use consistent variable names for recurring concepts.
%   The following names usually have the same meaning in all of the code:
%     pcc                        = Coefficients of PC expansion
%                                  >> pcc( index, point )
%     pci                        = Indices of Hermite polynomials of PC
%                                  expansion
%     n                          = Spatial number of nodes/dofs
%     m                          = Number of independent gaussian rvs
%                                  i.e. number of terms in KL expansion
%     p                          = Degree of PCE expansion
% Naming conventions
%     * always include the name of the basic variable in the name where
%     this expansion or whatever is referring to, i.e. if a variable u is
%     expanded somehow the coefficients should be named after u e.g.
%     u_alpha etc. 
%     * the indices of the expansion invoked on the variable are put behind
%     the base name in order of the expansion
%     * Examples:
%       u - could be a function from (x,omega) to R
%       u_n_j - could be the local univariate pce expansion
%       u_n_alpha - could be the local multivariate pce expansion
%       u_i_alpha - could be the multivariate pce expansion of the 
%                   coefficients of the kl eigenfunction
%     * How to name coefficients, eigenfunctions, random vars etc.


% Data structures
%   Hermite polynomials: 
%   Polynomials are usually expressed as column vectors in Matlab, i.e. a
%   polynomial p(x)=3x^2+5x-2 is represented as p=[3, 5, -2] (in this
%   order, highest index first). The coefficients for Hermite polynomials
%   in this package are represented a bit differently in that the lowest
%   index comes first (which, in my eyes, makes more sense from a
%   programmers point of view), i.e. if some PCE expansion of a random
%   variable returns something like p(x)=2 H_0(x) + 3 H_1(x) -4 H_2(x),
%   then the coefficients are stored as p=[2, 3, -4] (mark the order and
%   the semicolons). 
%   Matlab usually doesn't care whether you pass a row or a column vector
%   as a representation of a polynomial. Since we have to use arrays of
%   polynomial coefficients quite often, we have to make a difference. Thus
%   p=[2;3;-4] would mean 3 polynomial representations in Hermite
%   polynomials namely p1=2 H_0(x), p2=3 H_0(x) and p3=-4 H_0(x). Thus if
%   pcc represents the coefficients of a polynomials chaos expansion then
%   pcc(i,j) represents the coefficient of H_{j-1} in polynomial i. That
%   means:
%      p_i(x) = pcc(1,i) H_0(x) + pcc(2,i) H_1(x) + pcc(3,i) H_2(x) + ...
%   
%
%   Multivariate Hermite polynomials:  
%   For multivariate Hermite polynomials things get a bit more difficult
%   since the index of the polynomial can no longer be determined by the
%   order of the coefficient. Only for the very first coefficient we adopt
%   the convention that this should always refer to the constant
%   polynomial (i.e. H_0(xi1)*H_0(xi2)*H_0(xi3)*...). For all others we
%   have to remember which order the Hermite polynomials have for each of
%   the coefficients. The coefficients are ususally kept in an array by the
%   name of pci (polynomial chaos indices). 
%  
%   Coordinates:
%   In a coordinate array x the first index determines the point and the
%   seoncd index the dimension, i.e. x(i,2) is the y coordinate of point
%   x_i.



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
