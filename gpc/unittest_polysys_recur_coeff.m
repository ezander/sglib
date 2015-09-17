function unittest_polysys_recur_coeff
% UNITTEST_POLYSYS_RECUR_COEFF Test the POLYSYS_RECUR_COEFF function.
%
% Example (<a href="matlab:run_example unittest_polysys_recur_coeff">run</a>)
%   unittest_polysys_recur_coeff
%
% See also POLYSYS_RECUR_COEFF, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'polysys_recur_coeff' );

% Hermite
assert_equals(polysys_recur_coeff('H', 5), ...
    [[0,1,0]; [0,1,1]; [0,1,2]; [0,1,3]; [0,1,4]],'H_rc');

assert_equals(polysys_recur_coeff('h', 5), ...
    sqrt([[0,1,0]/1;
    [0,1,1]/2;
    [0,1,2]/3;
    [0,1,3]/4;
    [0,1,4]/5]), 'h_rc')

assert_equals(polysys_rc2coeffs(polysys_recur_coeff('H', 5)), [
    [0, 0, 0, 0, 0, 1]; [0, 0, 0, 0, 1, 0];
    [0, 0, 0, 1, 0, -1]; [0, 0, 1, 0, -3, 0];
    [0, 1, 0, -6, 0, 3]; [1, 0, -10, 0, 15, 0]], 'H_poly')

% Legendre
assert_equals(polysys_recur_coeff('P', 5), ...
    [[0,1,0]; [0,3,1]/2; [0,5,2]/3; [0,7,3]/4; [0,9,4]/5],'P_rc');

assert_equals(polysys_rc2coeffs(polysys_recur_coeff('P', 5)), [
    [0, 0, 0, 0, 0, 1]; [0, 0, 0, 0, 1, 0];
    [0, 0, 0, 3/2, 0, -1/2]; [0, 0, 5/2, 0, -3/2, 0];
    [0, 35/8, 0, -15/4, 0, 3/8]; [63/8, 0, -35/4, 0, 15/8, 0]], 'P_poly')

% Chebyshev first kind
assert_equals(polysys_recur_coeff('T', 5), ...
    [[0,1,1]; [0,2,1]; [0,2,1]; [0,2,1]; [0,2,1]],'T_rc');

assert_equals(polysys_rc2coeffs(polysys_recur_coeff('T', 5)), [
    [0, 0, 0, 0, 0, 1]; [0, 0, 0, 0, 1, 0];
    [0, 0, 0, 2, 0, -1]; [0, 0, 4, 0, -3, 0];
    [0, 8, 0, -8, 0, 1]; [16, 0, -20, 0, 5, 0]], 'T_poly')

% Chebyshev second kind
assert_equals(polysys_recur_coeff('U', 5), ...
    [[0,2,1]; [0,2,1]; [0,2,1]; [0,2,1]; [0,2,1]],'U_rc');

assert_equals(polysys_rc2coeffs(polysys_recur_coeff('U', 5)), [
    [0, 0, 0, 0, 0, 1]; [0, 0, 0, 0, 2, 0];
    [0, 0, 0, 4, 0, -1]; [0, 0, 8, 0, -4, 0];
    [0, 16, 0, -12, 0, 1]; [32, 0, -32, 0, 6, 0]], 'U_poly')

% Laguerre polynomials
assert_equals(polysys_recur_coeff('L', 5), ...
    [[1,-1,0]; [3,-1,1]/2; [5,-1,2]/3; [7,-1,3]/4; [9,-1,4]/5],'L_rc');

assert_equals(polysys_rc2coeffs(polysys_recur_coeff('L', 5)), [
    [0, 0, 0, 0, 0, 1]; [0, 0, 0, 0, -1, 1];
    [0, 0, 0, 1/2, -2, 1]; [0, 0, -1/6, 3/2, -3, 1];
    [0, 1/24, -2/3, 3, -4, 1]; [-1/120, 5/24, -5/3, 5, -5, 1]], 'L_poly')

% Monomials 
assert_equals(polysys_rc2coeffs(polysys_recur_coeff('M', 5)), fliplr(eye(6)), 'Mono_poly')

% error checking
assert_error( {@polysys_recur_coeff, {'?', 5}, {1,2}}, 'sglib:gpc', 'unknown polys' )




%p=polysys_rc2coeffs(polysys_recur_coeff('L', 5));
%rats2(p);
%disp(' ');
