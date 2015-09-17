% SFEM
%
% The methods in this package are for solving stochastic finite element
% problems. Contained are methods for computing the Karhunen-Loeve
% expansion, modifying boundary conditions for use in SFEM solves,
% synthesising random fields according to certain input statistics as input
% fields, etc.
%
% Polynomials chaos expansion
%   pce_field_realization                 - Compute a realization of a random field given by a
%   pce_transform_multi                   - Transform from local univariate to global
%   transform_covariance_pce              - Transforms covariance of underlying Gaussian
%
% Karhunen-Loeve expansion
%   kl_estimate_eps                       - Short description of kl_estimate_eps.
%   kl_pce_compute_operator               - Short description of kl_pce_compute_operator.
%   kl_pce_compute_operator_fast          - 
%   kl_pce_field_realization              - Compute a realization of a random field given by a
%   kl_pce_moments                        - no true documentation written so far.
%   kl_pce_solve_system                   - Short description of kl_pce_solve_system.
%   kl_pce_sparsity                       - Compute sparsity of a stochastic operator.
%   kl_pce_to_compact_form                - Short description of kl_pce_to_compact_form.
%   kl_pce_to_standard_form               - Short description of kl_pce_to_standard_form.
%   kl_remainder                          - 
%   kl_solve_1d_exp                       - Solve the 1D KL problem for the exponential covariance.
%   kl_solve_evp                          - Solve the Karhunen-Loeve eigenvalue problem.
%   kl_to_pce                             - Short description of kl_to_pce.
%   kl_to_ctensor                         - Pack a KL expansion into tensor product format.
%   pce_to_kl                             - Reduce a pure PCE field into a KL-PCE field.
%   project_pce_on_kl                     - Project a spatially PC expanded field into a KL-PCE field.
%   ctensor_to_kl                         - Unpack a KL expansion from a tensor product.
%
% Random field expansion
%   expand_field_kl_pce                   - 
%   expand_field_pce_sg                   - Compute the PC expansion of a random field according to a paper of Sakamoto and Ghanem.
%   expand_gaussian_field_pce             - See also PLOT_PCE_REALIZATIONS_1D, COVARIANCE_MATRIX, TRANSFORM_COVARIANCE_PCE, PCE_TO_KL
%
% Covariances
%   covariance_matrix                     - Calculate point covariance matrix.
%
% Stochastic Galerkin method
%   stochastic_preconditioner             - Create the mean based preconditioner from a stochastic operator.
%
% Unittests
%   unittest_covariance_matrix            - Test covariance related functions.
%   unittest_kl_estimate_eps              - Test the KL_ESTIMATE_EPS function.
%   unittest_kl_pce_compute_operator      - Test the KL_PCE_COMPUTE_OPERATOR function.
%   unittest_kl_pce_compute_operator_fast - Test the KL_PCE_COMPUTE_OPERATOR_FAST function.
%   unittest_kl_pce_moments               - Test the KL_PCE_MOMENTS function.
%   unittest_kl_pce_to_compact_form       - Test the KL_PCE_TO_COMPACT_FORM function.
%   unittest_kl_pce_to_standard_form      - Test the KL_PCE_TO_STANDARD_FORM function.
%   unittest_kl_solve_evp                 - Test the KL_SOLVE_EVP function.
%   unittest_kl_tensor                    - Test the KL_TO_CTENSOR and CTENSOR_TO_KL functions.
%   unittest_pce_to_kl                    - Test the PCE_TO_KL function.
