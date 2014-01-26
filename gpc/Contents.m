% GPC Description of the gpc functions.
%   Basically the GPC functions work just like PCE functions with one small
%   difference: where for the PCE it was enough to specify a multiindex
%   set, for GPC you have to specify the type polynomials as well. In sglib
%   there are two ways of doing that: either you have one set of
%   polynomials for all random variables or they can be different. In the
%   first case, to have normalised Hermite polynomials for everything, you
%   would specify
%      V_a = {'h', multiindex(4, 2)}
%   and pass that to one of the GPC functions. If you want normalised and
%   non-normalised polynomials of different type you could use e.g.
%      V_a = {'hHpP', multiindex(4, 2)}
%   Note that generally the functions that use only one type of polynomials
%   are faster. So, its also better to say {'h', multiindex(4, 2)} instead
%   of {'hhhh', multiindex(4, 2)}, even though they compute the same thing.
%
%   The polynomials systems are defined in the following way: Each system
%   is represented by a single letter, which is the usual mathematical
%   notation for that system, e.g. 'H' for Hermite polynomials, 'P' for
%   Legendre polynomials. If the polynomials shall be normalised a small
%   letter must be used, e.g. 'h' for normalised Hermite polynomials. The
%   following systems are defined within sglib:
%
%     H, h: stochastic Hermite polynomials
%     P, p: Legendre polynomials (on (-1, 1))
%     L, l: Laguerre polynomials
%     T, t: Chebyshev polynomials, 1st kind
%     U, u: Chebyshev polynomials, 2nd kind
%
%   The corresponding random variables are:
%     N(0,1):   standard normal, i.e. mean 0, variance 1
%     U(-1, 1): uniform on (-1,1)
%     Exp(1):   exponential distribution with parameter 1
%     AS:       shifted Arcsine distribution on [-1, 1]
%     W(1):     Wigner semicircle distribution, 2*Beta(3/2,3/2)-1
%
%   Further, as a convenience, with some functions you can use 'M' for the
%   monomials. Note, however, that this does not work for all functions
%   since there is no probability measure associated with the monomials.
%
% Todo:
%     * gpc_add and gpc_multiply needs to be implemented
%     * need functions to manipulate the {polysys, multiindex} pairs (call
%       them gpcspace?)
%     * better performance for mixed case by caching over polynomials
%       systems
%
% Files
%
% GPC functions (high level)
%   gpcbasis_create              - Short description of gpcspace_create.
%   gpcbasis_evaluate            - Evaluates the GPC basis functions at given points.
%   gpcbasis_norm                - Compute the norm of the system of GPC polynomials.
%   gpcbasis_size                - Return the size of the GPC basis.
%   gpc_covariance               - Compute covariance matrix between GPC variables.
%   gpc_evaluate                 - Evaluate a GPC at a given number of sample points.
%   gpc_integrate                - Short description of gpc_integrate.
%   gpc_moments                  - Calculate the statistical moments of a distribution given as GPC.
%   gpc_partial_eval             - Partially evaluates a GPC and returns the reduced GPC.
%   gpc_sample                   - Draw samples from a GPC.
%   gpc_triples                  - Computation of the expectation of triple products of gpc polynomials.
%   unittest_gpcbasis_create     - Test the GPCBASIS_CREATE function.
%   unittest_gpcbasis_evaluate   - Test the GPCBASIS_EVALUATE function.
%   unittest_gpcbasis_norm       - Test the GPCBASIS_NORM function.
%   unittest_gpcbasis_size       - Test the GPCBASIS_SIZE function.
%   unittest_gpc_covariance      - Test the GPC_COVARIANCE function.
%   unittest_gpc_evaluate        - Test the GPC_EVALUATE function.
%   unittest_gpc_integrate       - Test the GPC_INTEGRATE function.
%   unittest_gpc_moments         - Test the GPC_MOMENTS function.
%   unittest_gpc_partial_eval    - Test the GPC_PARTIAL_EVAL function.
%   unittest_gpc_sample          - Test the GPC_SAMPLE function.
%   unittest_gpc_triples         - Test the GPC_TRIPLES function.
% 
% Polysys functions (low level)
%   polysys_int_rule             - Short description of polysys_int_rule.
%   polysys_rc2coeffs            - Generate polynomial coefficients from recurrence.
%   polysys_recur_coeff          - Compute recurrence coefficient of orthogonal polynomials.
%   polysys_sample_rv            - Sample from a probability distribution.
%   polysys_sqnorm               - POLYSYS_NORM Compute the square norm of the orthogonal polynomials.
%   unittest_polysys_int_rule    - Test the POLYSYS_INT_RULE function.
%   unittest_polysys_recur_coeff - Test the POLYSYS_RECUR_COEFF function.
%   unittest_polysys_sample_rv   - Test the POLYSYS_SAMPLE_RV function.
%   unittest_polysys_sqnorm      - Test the POLYSYS_SQNORM function.
%

%   Elmar Zander
%   Copyright 2012, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

