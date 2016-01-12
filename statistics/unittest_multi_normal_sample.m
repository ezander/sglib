function unittest_multi_normal_sample(varargin)
% UNITTEST_MULTI_NORMAL_SAMPLE Test the MULTI_NORMAL_SAMPLE function.
%
% Example (<a href="matlab:run_example unittest_multi_normal_sample">run</a>)
%   unittest_multi_normal_sample
%
% See also MULTI_NORMAL_SAMPLE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'multi_normal_sample' );

munit_control_rand('seed', 1234);

m = 6;
N = 100000;
mu_1 = 3;
mu_M = (1:m)';
sigma2_11 = 1.4;
sigma2_M1 = linspace(0.2, 0.3, m)';
A = rand(m-2,m);
sigma2_MM = A'*A;

% Test case 1: XI=Mx1, SIGMA2=MxM
xi = multi_normal_sample(N, mu_M, sigma2_MM);
assert_equals(mean(xi, 2), mu_M, 'mu_MMM', 'abstol', 0.01);
assert_equals(cov(xi'), sigma2_MM, 'cov_MMM', 'reltol', 0.05);

% Test case 2: XI=Mx1, SIGMA2=Mx1
xi = multi_normal_sample(N, mu_M, sigma2_M1);
assert_equals(mean(xi, 2), mu_M, 'mu_MM1', 'abstol', 0.01);
assert_equals(cov(xi'), diag(sigma2_M1), 'cov_MM1', 'abstol', 0.01);

% Test case 3: XI=Mx1, SIGMA2=1x1
xi = multi_normal_sample(N, mu_M, sigma2_11);
assert_equals(mean(xi, 2), mu_M, 'mu_M11', 'abstol', 0.01);
assert_equals(cov(xi'), sigma2_11*eye(m), 'cov_M11', 'abstol', 0.04);

% Test case 4: XI=1x1, SIGMA2=MxM
xi = multi_normal_sample(N, mu_1, sigma2_MM);
assert_equals(mean(xi, 2), repmat(mu_1,m,1), 'mu_1MM', 'abstol', 0.01);
assert_equals(cov(xi'), sigma2_MM, 'cov_1MM', 'abstol', 0.01);

% Test case 5: XI=1x1, SIGMA2=Mx1
xi = multi_normal_sample(N, mu_1, sigma2_M1);
assert_equals(mean(xi, 2), repmat(mu_1,m,1), 'mu_1M1', 'abstol', 0.01);
assert_equals(cov(xi'), diag(sigma2_M1), 'cov_1M1', 'abstol', 0.01);
