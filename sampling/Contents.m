% SAMPLING
%
% This folder contains functions for support of sampling based methods like
% quasi Monte Carlo (QMC) and Latin hypercube (LHS) based methods. Many of
% the methods can also be invoked indirectly (and more conveniently) via
% the GPC functions (see GPCGERM_SAMPLE).
%
% Files
%   halton_sequence          - Generate a Halton sequence for QMC integration.
%   hammersley_set           - Generates the Hammersley set.
%   lhs_plot_grid            - Plot a Latin hypercube grid.
%   lhs_uniform              - Generate uniform Latin hypercube samples.
%   nprimes                  - Return a list with an exact number of primes.
%   randn_sorted             - Generate sorted, normally distributed numbers from the inverse CDF.
%   van_der_corput           - Compute the van der Corput sequence.
%
% Unittests
%   unittest_halton_sequence - Test the HALTON_SEQUENCE function.
%   unittest_hammersley_set  - Test the HAMMERSLEY_SET function.
%   unittest_lhs_uniform     - Test the LHS_UNIFORM function.
%   unittest_nprimes         - Test the NPRIMES function.
%   unittest_randn_sorted    - Test the RANDN_SORTED function.
%   unittest_van_der_corput  - Test the VAN_DER_CORPUT function.
%
% Demos (should go somewhere else)
%   demo_halton              - 
%   demo_hess_polak          - http://ideas.repec.org/p/wiw/wiwrsa/ersa03p406.html
