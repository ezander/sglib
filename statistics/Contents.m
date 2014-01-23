% STATISTICS
%
% Files
%   beta_cdf                               - Cumulative distribution function of the beta distribution.
%   beta_find_ratio                        - Find parameters for the beta distribution that have a specific stddev to mean ratio.
%   beta_invcdf                            - Inverse CDF of the Beta distribution.
%   beta_moments                           - Compute moments of the beta distribution.
%   beta_pdf                               - Probability distribution function of the beta distribution.
%   beta_raw_moments                       - Compute raw moments of the beta distribution.
%   beta_stdnor                            - Transforms standard normal random numbers into beta distributed ones.
%   cross_correlation                      - Compute cross correlation coefficient between functions.
%   data_moments                           - Compute moments of given data.
%   empirical_density                      - Probability density estimation for given data.
%   exponential_cdf                        - Cumulative distribution function of the exponential distribution.
%   exponential_covariance                 - Compute the exponential covariance function.
%   exponential_invcdf                     - Inverse CDF of the Exponential distribution.
%   exponential_moments                    - Compute moments of the exponential distribution.
%   exponential_pdf                        - Probability distribution function of the exponential distribution.
%   exponential_raw_moments                - Compute raw moments of the exponential distribution.
%   exponential_stdnor                     - Transforms standard normal random numbers into exponential distributed ones.
%   gaussian_covariance                    - Compute the Gaussian covariance function.
%   gendist_cdf                            - Cumulative distribution function of a gendist.
%   gendist_create                         - Create a structure that describes a statistical distribution.
%   gendist_fix_bounds                     - Fixes the bounds for distributions on bounded intervals.
%   gendist_fix_moments                    - Generates a new gendist with specified moments.
%   gendist_invcdf                         - Inverse CDF (quantile function) of a gendist.
%   gendist_moments                        - Compute moments for a gendist.
%   gendist_pdf                            - Probability distribution function for a gendist.
%   gendist_sample                         - Draw random samples from a gendist.
%   gendist_stdnor                         - Short description of gendist_stdnor.
%   kendall_correlation                    - Short description of kendall_correlation.
%   kernel_density                         - Kernel density estimation for given data.
%   ks_test                                - Perform the Kolmogorov-Smirnov test on the samples distribution.
%   lognormal_cdf                          - Cumulative distribution function of the lognormal distribution.
%   lognormal_invcdf                       - Inverse CDF of the Lognormal distribution.
%   lognormal_moments                      - Compute moments of the lognormal distribution.
%   lognormal_pdf                          - Probability distribution function of the lognormal distribution.
%   lognormal_raw_moments                  - Compute raw moments of the lognormal distribution.
%   lognormal_stdnor                       - Transforms standard normal random numbers into lognormal distributed ones.
%   matern_covariance                      - Compute the Matern covariance function.
%   normal_cdf                             - Cumulative distribution function of the normal distribution.
%   normal_invcdf                          - Inverse CDF of the Normal distribution.
%   normal_moments                         - Compute moments of the normal distribution.
%   normal_pdf                             - Probability distribution function of the normal distribution.
%   normal_raw_moments                     - Compute raw moments of the normal distribution.
%   normal_sample                          - Draws random samples from the normal distribution.
%   normal_stdnor                          - Transforms standard normal random numbers into normal distributed ones.
%   pearson_correlation                    - Computes the (Pearson) correlation coefficient.
%   rational_quadratic_covariance          - Compute the rational quadratic covariance function.
%   spearman_correlation                   - Computes the Spearman rank correlation coefficient.
%   spherical_covariance                   - Compute the spherical covariance function.
%
% Unittests
%   uniform_cdf                            - Cumulative distribution function of the uniform distribution.
%   uniform_invcdf                         - Inverse CDF of the Uniform distribution.
%   uniform_moments                        - Compute moments of the uniform distribution.
%   uniform_pdf                            - Probability distribution function of the uniform distribution.
%   uniform_raw_moments                    - Compute raw moments of the uniform distribution.
%   uniform_stdnor                         - Transforms standard normal random numbers into uniform distributed ones.
%   unittest_beta_distribution             - Test the distribution functions.
%   unittest_beta_find_ratio               - Test the BETA_FIND_RATIO function.
%   unittest_cross_correlation             - Test the CROSS_CORRELATION function.
%   unittest_data_moments                  - Test the DATA_MOMENTS function.
%   unittest_empirical_density             - Test the EMPIRICAL_DENSITY function.
%   unittest_exponential_covariance        - Test the EXPONENTIAL_COVARIANCE function.
%   unittest_exponential_distribution      - Test the distribution functions.
%   unittest_gaussian_covariance           - Test the GAUSSIAN_COVARIANCE function.
%   unittest_gendist                       - Test the GENDIST function.
%   unittest_gendist_fix_bounds            - Test the GENDIST_FIX_BOUNDS function.
%   unittest_gendist_fix_moments           - Test the GENDIST_FIX_MOMENTS function.
%   unittest_gendist_sample                - Test the GENDIST_SAMPLE function.
%   unittest_kernel_density                - Test the KERNEL_DENSITY function.
%   unittest_lognormal_distribution        - Test the distribution functions.
%   unittest_matern_covariance             - Test the MATERN_COVARIANCE function.
%   unittest_moments                       - Test the moment computing functions.
%   unittest_normal_distribution           - Test the distribution functions.
%   unittest_rational_quadratic_covariance - Test the RATIONAL_QUADRATIC_COVARIANCE function.
%   unittest_uniform_distribution          - Test the distribution functions.
