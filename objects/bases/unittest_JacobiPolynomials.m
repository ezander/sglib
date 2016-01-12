function unittest_JacobiPolynomials
% UNITTEST_JACOBIPOLYNOMIALS Test the JACOBIPOLYNOMIALS function.
%
% Example (<a href="matlab:run_example unittest_JacobiPolynomials">run</a>)
%   unittest_JacobiPolynomials
%
% See also HERMITEPOLYNOMIALS, MUNIT_RUN_TESTSUITE 

%   Noemi Friedman
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'JacobiPolynomials' );

%% Initialization
J=JacobiPolynomials(-0.5,-0.5);

%% Recur_coeff
r=J.recur_coeff(3);
assert_equals(r, ...
    [[0,0.5,0]; [0,1.5,0.375]; [0,5/3,0.625]],'recur_coeff');

J=JacobiPolynomials(1.5,1.5);
r=J.recur_coeff(3);
assert_equals(r, ...
[0, 2.5, 0.9375;  0, 2.1,0.8750;0, 2, 0.875],'recur_coeff');

%% evaluate
J=JacobiPolynomials(0.5,0.5);
xi=[1,2,3];
y=J.evaluate(2, xi);
assert_equals(y,[1 1 1;1.5 3 4.5;1.875 9.375 21.875]', 'evaluate');

%% check equivalencies with other polynomials in case of pecial ALPHA and BETA values 
% equivalence with ChebyshevU
n=0:3;
xi=[1,2,3,4,5];
y=J.evaluate(3, xi);
y_j=binfun(@times, y, (n+1));
y_j=binfun(@times, y_j, 1./y(1,:) );
U=ChebyshevUPolynomials();
y_u=U.evaluate(3,xi);

assert_equals(y_j, y_u,'check_equivalence_with_ChebyshevU');

% equivalence with ChebyshevT
J=JacobiPolynomials(-0.5,-0.5);
y=J.evaluate(3, xi);
y_j=binfun(@times, y, 1./y(1,:) );
T=ChebyshevTPolynomials();
y_T=T.evaluate(3,xi);

assert_equals(y_j, y_T,'check_equivalence_with_ChebyshevT');

%  equivalence with Legendre Polynomials
J=JacobiPolynomials(0,0);
y_j=J.evaluate(3, xi);
P=LegendrePolynomials();
y_P=P.evaluate(3,xi);

assert_equals(y_j, y_P,'check_equivalence_with_Legendre');


%% norm 
J = JacobiPolynomials(0,0);
P=LegendrePolynomials();
n = [0 1; 3 5];
h = P.sqnorm(n);
assert_equals(J.sqnorm(n), h, 'nrm_arr');
assert_equals(J.sqnorm(n(:)), h(:), 'nrm_col');
assert_equals(J.sqnorm(n(:)'), h(:)', 'nrm_row');

% TODO: need to check the sqnorm stuff better
% I think it will be best to check consistency, e.g. together with
% integration of the polys over the weight functions

%% consistency with weighting function
polysys = JacobiPolynomials(1.3, 3.4);
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
