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
%   pce_expand_1d                      - Calculate the PC expansion in one stochastics dimension.
%   pce_expand_1d_mc                   - Calculate the PCE expansion in one stochastics dimension (MC).
%   pce_moments                        - Calculate the statistical moments of a distribution given as PCE.
%   pce_normalize                      - Transforms a PCE in unnormed Hermite polys into a PCE in normed Hermite polys.
%   pce_covariance                     - Computes the covariance between variables in a PC
%   pce_field_realization              - Compute a realization of a random field given by a
%   pce_transform_multi                - Transform from local univariate to global
%   pce_cdf                            - Short description of pce_cdf.
%   pce_cdf_1d                         - Compute cumulative distribution for univariate PCE.
%   pce_divide                         - Divide two PC expanded random variables.
%   pce_evaluate                       - Evaluate a PCE random variable at a given sample point.
%   pce_multiply                       - Multiply two PC expanded random variables.
%   pce_pdf                            - Short description of pce_pdf.
%   pce_pdf_1d                         - 
%
% Karhunen-Loeve expansion
%   kl_solve_evp                       - Solve the Karhunen-Loeve eigenvalue problem.
%   kl_pce_field_realization           - Compute a realization of a random field given by a
%   pce_to_kl                          - Reduce a pure PCE field into a KL-PCE field.
%   project_pce_on_kl                  - Project a spatially PC expanded field into a KL-PCE field.
%
% Random field expansion
%   expand_field_pce_sg                - Compute the PC expansion of a random field according to a paper of Sakamoto and Ghanem.
%
% Covariances
%   covariance_matrix                  - Calculate point covariance matrix.
%   transform_covariance_pce           - Transforms covariance of underlying Gaussian
%
% Miscellaneous numerical routines
%   gram_schmidt                       - Perform Gram-Schmidt orthogonalization.
%   solver_message                     - TODO: need to rewrite from scratch, so it can be put under GPL (this is a
%
% Stochastic Galerkin method
%   compute_pce_operator               - COMPUTE_PCE_MATRIX Compute the operator that represents multiplication with PC expanded random field.
%   compute_pce_matrix                 - Compute the matrix that represents multiplication in the Hermite algebra.
%   compute_pce_rhs                    - Compute the right hand side in a linear equation involving the PCE.
%
% Application of boundary conditions to tensors and tensor operators
%   boundary_projectors                - Projection matrices on the set of inner and boundary nodes.
%   apply_boundary_conditions_operator - Apply essential boundary conditions to operator.
%   apply_boundary_conditions_rhs      - Apply essential boundary conditions to right hand side.
%   apply_boundary_conditions_solution - Applies boundary conditions to the solution.
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


% PLEASE KEEP THE EMPTY LINE ABOVE SO THAT THE TEST FUNCTIONS DONT CLUTTER
% UP THE CONTENTS DISPLAY.
% Test and demo functions/scripts
%   testsuite                          - Run all unit tests in this directory.
%   unittest_apply_boundary_conditions - Test the APPLY_BOUNDARY_CONDITIONS function.
%   unittest_compute_pce_matrix        - Test the compute_pce_matrix function.
%   unittest_covariance                - Test covariance related functions.
%   unittest_gram_schmidt              - Test the GRAM_SCHMIDT function
%   unittest_hermite                   - Test the HERMITE function.
%   unittest_hermite_triples           - Test the HERMITE_TRIPLE_PRODUCT and HERMITE_TRIPLE_FAST functions.
%   unittest_hermite_val               - Test the HERMITE_VAL function.
%   unittest_hermite_val_multi         - Test the hermite_val_multi function.
%   unittest_kl_solve_evp              - Test the KL_SOLVE_EVP function.
%   unittest_multiindex                - Test the MULTIINDEX function.
%   unittest_pce_normalize             - Test the PCE_NORMALIZE function.
%   unittest_pce_expand_1d             - Test the univariate PCE expansion
%   unittest_pce_moments               - Test the PCE_MOMENTS function.
%   unittest_pce_to_kl                 - function unittest_pce_to_kl
%   unittest_compute_pce_operator      - Test the COMPUTE_PCE_OPERATOR function.
%   unittest_compute_pce_rhs           - Test the COMPUTE_PCE_RHS function.
%   unittest_hermite_norm              - Test the HERMITE_NORM function.
%   unittest_multiindex_combine        - Test the MULTIINDEX_COMBINE function.
%   unittest_multiindex_factorial      - Test the MULTIINDEX_FACTORIAL function.
%   unittest_multiindex_find           - Test the MULTIINDEX_FIND function.
%   unittest_multiindex_order          - Test the MULTIINDEX_ORDER function.
%   unittest_pce_cdf_1d                - Test the PCE_CDF_1D function.
%   unittest_pce_divide                - Test the PCE_DIVIDE function.
%   unittest_pce_evaluate              - Test the PCE_EVALUATE function.
%   unittest_pce_expand_1d_mc          - UNITTEST_PCE_EXPAND_1D Test the univariate PCE expansion
%   unittest_pce_multiply              - Test the PCE_MULTIPLY function.



%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


