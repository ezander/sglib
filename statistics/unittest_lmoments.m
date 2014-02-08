function unittest_lmoments
% UNITTEST_LMOMENTS Test the LMOMENTS function.
%
% Example (<a href="matlab:run_example unittest_lmoments">run</a>)
%   unittest_lmoments
%
% See also LMOMENTS, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'lmoments' );

% we test by trying to reproduce some given L-moments by sampling from
% certain distribution and comparing that to the values as given in the
% wikipedia article

N=10000;
r = linspace(0.5/N, 1-0.5/N, N);

% Uniform distribution
a = 2; b = 4.5;
x = uniform_invcdf(r, a, b);
lm_uniform_exact = [(a+b)/2, (b-a)/6, 0, 0];
lm_uniform_empiric = lmoments(x);
assert_equals(lm_uniform_empiric, lm_uniform_exact, 'uniform', 'abstol', 0.0001);

% Normal distribution
mu = 2; sigma = 0.6;
x = normal_invcdf(r, mu, sigma);
lm_normal_exact = [mu, sigma/sqrt(pi), 0, 0.1226];
lm_normal_empiric = lmoments(x);
assert_equals(lm_normal_empiric, lm_normal_exact, 'normal', 'abstol', 0.0001);

% Exponential
lambda=1.3;
x = exponential_invcdf(r, lambda);
lm_exponential_exact = [1/lambda, 0.5/lambda, 1/3, 1/6];
lm_exponential_empiric = lmoments(x);
assert_equals(lm_exponential_empiric, lm_exponential_exact, 'exp', 'abstol', 0.0001);
