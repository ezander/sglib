function unittest_LaguerrePolynomials
% UNITTEST_LAGUERREPOLYNOMIALS Test the LAGUERREPOLYNOMIALS function.
%
% Example (<a href="matlab:run_example unittest_LaguerrePolynomials">run</a>)
%   unittest_LaguerrePolynomials
%
% See also LAGUERREPOLYNOMIALS, MUNIT_RUN_TESTSUITE 

%   Aidin Nojavan
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'LaguerrePolynomials' );

%% Initialization
L=LaguerrePolynomials();

%% Recur_coeff
r=L.recur_coeff(3);
assert_equals(r,[1 -1 0;1.5 -0.5 0.5;5/3 -1/3 2/3],'recur_coeff');

%% evaluate
xi=[1,2,3,4];
y=L.evaluate(2, xi);
assert_equals(y,[1 0 -0.5;1 -1 -1;1 -2 -0.5;1 -3 1],'evaluate');

%% norm
n = [0 1; 3 5];
h = [1 1; 1 1];
assert_equals(L.sqnorm(n), h, 'nrm_arr');
assert_equals(L.sqnorm(n(:)), h(:), 'nrm_col');
assert_equals(L.sqnorm(n(:)'), h(:)', 'nrm_row');

%% normalized
assert_true(isa(L.normalized(), class(L)), 'Laguerre.normalized should return the same object', 'same');

%% consistency with weighting function
polysys = LaguerrePolynomials();
N=4;

% polysys -> dist
dist = polysys.weighting_dist();
Q = compute_gramian(polysys, dist, N);
assert_equals(Q, diag(polysys.sqnorm(0:N)), 'weighting_consistent');

% dist -> polysys
polysys = dist.default_polysys(false);
Q = compute_gramian(polysys, dist, N);
assert_equals(Q, diag(polysys.sqnorm(0:N)), 'weighting_consistent_rev');

polysys = dist.default_polysys(true);
Q = compute_gramian(polysys, dist, N);
assert_equals(Q, eye(N+1), 'weighting_consistent_rev_norm');
