function unittest_NormalizedPolynomials(varargin)
% UNITTEST_NORMALIZEDPOLYNOMIALS Test the NORMALIZEDPOLYNOMIALS function.
%
% Example (<a href="matlab:run_example unittest_NormalizedPolynomials">run</a>)
%   unittest_NormalizedPolynomials
%
% See also NORMALIZEDPOLYNOMIALS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'NormalizedPolynomials' );

%% normalizing
P=LegendrePolynomials();
P_n = P.normalized();
n = [0 1; 3 5];
assert_equals(P_n.sqnorm(n), ones(size(n)), 'nrm_arr');

%% normalizing 2
xi=[1,2,3,4];
h = P.sqnorm(0:6);
y_n = P_n.evaluate(6, xi);
y = P.evaluate(6, xi);
assert_equals(y_n, binfun(@times, y, 1./sqrt(h)), 'normed');

%% double normalizing
P_n2 = P_n.normalized();
assert_equals(P_n2.evaluate(6, xi), P_n.evaluate(6, xi), 'double');
assert_true(isa(P_n2.base_polysys, class(P)), 'Double normalizing should not wrap again', 'no_wrap');

%%
polysys = P_n;
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
