function unittest_HermitePolynomials
% UNITTEST_HERMITEPOLYNOMIALS Test the HERMITEPOLYNOMIALS function.
%
% Example (<a href="matlab:run_example unittest_HermitePolynomials">run</a>)
%   unittest_HermitePolynomials
%
% See also HERMITEPOLYNOMIALS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'HermitePolynomials' );
%% Initialization
H=HermitePolynomials(5);
assert_equals(H.deg,5,'initialization');
%% Recur_coeff
r=H.recur_coeff();
assert_equals(r, ...
    [[0,1,0]; [0,1,1]; [0,1,2]; [0,1,3]; [0,1,4]],'recur_coeff');

H=HermitePolynomials(3);
r=H.recur_coeff();
assert_equals(r,[0 1 0;0 1 1;0 1 2],'recur_coeff');
%% evaluate
xi=[1,2,3,4];
y=H.evaluate(xi);
assert_equals(y,[1 1 0;1 2 3;1 3 8;1 4 15],'evaluate');
