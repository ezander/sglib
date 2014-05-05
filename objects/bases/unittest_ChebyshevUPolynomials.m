function unittest_ChebyshevUPolynomials
% UNITTEST_CHEBYSHEVUPOLYNOMIALS Test the CHEMYSHEV2POLYNOMIAL function.
%
% Example (<a href="matlab:run_example unittest_ChebyshevUPolynomials">run</a>)
%   unittest_ChebyshevUPolynomials
%
% See also CHEMYSHEV2POLYNOMIAL, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'Chemyshev2Polynomial' );
%% Initialization
C=ChebyshevUPolynomials(4);
assert_equals(C.deg,4,'initialization');
%% Recur_coeff
r=C.recur_coeff();
assert_equals(r,[[0,2,1];[0,2,1];[0,2,1];[0,2,1]],'recur_coeff');

%% evaluate
xi=[1,2,3,4];
y=C.evaluate(xi);
assert_equals(y,[1 2 3 4;1 4 15 56; 1 6 35 204; 1 8 63 496],'evaluate');

