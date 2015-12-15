function unittest_HermitePolynomials
% UNITTEST_HERMITEPOLYNOMIALS Test the HERMITEPOLYNOMIALS function.
%
% Example (<a href="matlab:run_example unittest_HermitePolynomials">run</a>)
%   unittest_HermitePolynomials
%
% See also HERMITEPOLYNOMIALS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'HermitePolynomials' );

%% Initialization
H=HermitePolynomials();

%% Recur_coeff
r=H.recur_coeff(5);
assert_equals(r, ...
    [[0,1,0]; [0,1,1]; [0,1,2]; [0,1,3]; [0,1,4]],'recur_coeff');

r=H.recur_coeff(3);
assert_equals(r,[0 1 0;0 1 1;0 1 2],'recur_coeff');

%% evaluate
xi=[1,2,3,4];
y=H.evaluate(2, xi);
assert_equals(y,[1 1 0;1 2 3;1 3 8;1 4 15],'evaluate');

%% norm
n = [0 1; 3 5];
h = [1 1; 6 120];
assert_equals(H.sqnorm(n), h, 'nrm_arr');
assert_equals(H.sqnorm(n(:)), h(:), 'nrm_col');
assert_equals(H.sqnorm(n(:)'), h(:)', 'nrm_row');

%% consistency with weighting function
polysys = HermitePolynomials();
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
