% PCE
%
% This folder contains methods for generating and working with the
% polynomial chaos expansion (PCE). Note that many of the functions are
% obsolete now and should be replaced by functions from GPC, which are
% (partly) more efficient and numerically stable.
%
% Function for SGEM and PCE multiplication
%   compute_pce_matrix            - Compute the matrix that represents multiplication in the Hermite algebra.
%   compute_pce_operator          - COMPUTE_PCE_MATRIX Compute the operator that represents multiplication with PC expanded random field.
%   compute_pce_rhs               - Compute the right hand side in a linear equation involving the PCE.
%
% Hermite polynomials
%   hermite                       - Return the n-th Hermite polynomial.
%   hermite_norm                  - Compute the norm of multivariate Hermite polynomials.
%   hermite_triple_fast           - Cached computation of the expectation of triple products of Hermite polynomials.
%   hermite_triple_product        - Compute expectation of triple products of Hermite polynomials.
%   hermite_val                   - Evaluate expansion in Hermite polynomials.
%   hermite_val_multi             - Evaluate expansion in multivariate Hermite polynomials.
%
% Basic PCE functions
%   pce_cdf                       - Short description of pce_cdf.
%   pce_cdf_1d                    - Compute cumulative distribution for univariate PCE.
%   pce_covariance                - Computes the covariance between variables in a PC
%   pce_divide                    - Divide two PC expanded random variables.
%   pce_error_est                 - Computes the L2-error between two PCE expansions.
%   pce_error_mc                  - Evalutes the difference between two PCE reps .
%   pce_evaluate                  - Evaluate a PCE random variable at a given sample point.
%   pce_expand_1d                 - Calculate the PC expansion in one stochastics dimension.
%   pce_expand_1d_mc              - Calculate the PCE expansion in one stochastics dimension (MC).
%   pce_moments                   - Calculate the statistical moments of a distribution given as PCE.
%   pce_multiply                  - Multiply two PC expanded random variables.
%   pce_normalize                 - Transforms a PCE in unnormed Hermite polys into a PCE in normed Hermite polys.
%   pce_pdf                       - Short description of pce_pdf.
%   pce_pdf_1d                    - 
%
% Unittests
%   unittest_compute_pce_matrix   - Test the compute_pce_matrix function.
%   unittest_compute_pce_operator - Test the COMPUTE_PCE_OPERATOR function.
%   unittest_compute_pce_rhs      - Test the COMPUTE_PCE_RHS function.
%   unittest_hermite              - Test the HERMITE function.
%   unittest_hermite_norm         - Test the HERMITE_NORM function.
%   unittest_hermite_triples      - Test the HERMITE_TRIPLE_PRODUCT and HERMITE_TRIPLE_FAST functions.
%   unittest_hermite_val          - Test the HERMITE_VAL function.
%   unittest_hermite_val_multi    - Test the hermite_val_multi function.
%   unittest_pce_cdf_1d           - Test the PCE_CDF_1D function.
%   unittest_pce_divide           - Test the PCE_DIVIDE function.
%   unittest_pce_error_est        - Test the PCE_ERROR_EST function.
%   unittest_pce_error_mc         - Test the PCE_ERROR_MC function.
%   unittest_pce_evaluate         - Test the PCE_EVALUATE function.
%   unittest_pce_expand_1d        - Test the univariate PCE expansion
%   unittest_pce_expand_1d_mc     - UNITTEST_PCE_EXPAND_1D Test the univariate PCE expansion
%   unittest_pce_moments          - Test the PCE_MOMENTS function.
%   unittest_pce_multiply         - Test the PCE_MULTIPLY function.
%   unittest_pce_normalize        - Test the PCE_NORMALIZE function.
