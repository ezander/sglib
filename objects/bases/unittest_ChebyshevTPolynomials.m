function unittest_ChebyshevTPolynomials
% UNITTEST_CHEBYSHEVTPOLYNOMIALS Test the CHEBYSHEVTPOLYNOMIALS function.
%
% Example (<a href="matlab:run_example unittest_ChebyshevTPolynomials">run</a>)
%   unittest_ChebyshevTPolynomials
%
% See also CHEBYSHEVTPOLYNOMIALS, MUNIT_RUN_TESTSUITE 

%   Aidin Nojavan slightly modified by Noemi Friedman
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'ChebyshevTPolynomials' );

%% Initialization
T=ChebyshevTPolynomials();

%% Recur_coeff
r=T.recur_coeff(4);
assert_equals(r,[[0,1,1];[0,2,1];[0,2,1];[0,2,1]],'recur_coeff');

%% evaluate
xi=[1,2,3,4];
y=T.evaluate(3, xi);
assert_equals(y,[1 1 1 1;1 2 7 26 ;1 3 17 99;1 4 31 244],'evaluate');

%% norm
n = [0 1; 3 5];
h = [1 0.5; 0.5 0.5];
assert_equals(T.sqnorm(n), h, 'nrm_arr');
assert_equals(T.sqnorm(n(:)), h(:), 'nrm_col');
assert_equals(T.sqnorm(n(:)'), h(:)', 'nrm_row');

%% consistency with weighting function
polysys = ChebyshevTPolynomials();
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
