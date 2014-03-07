function unittest_Operator
% UNITTEST_OPERATOR Test the OPERATOR function.
%
% Example (<a href="matlab:run_example unittest_Operator">run</a>)
%   unittest_Operator
%
% See also OPERATOR, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'Operator' );


% We test most of the stuff via the MatrixOperator, since we can't
% instantiate the Operator directly

% Basic stuff
A = rand(3,5);
mop = MatrixOperator(A);
assert_equals(mop.asmatrix(), A);
assert_equals(size(mop), [3, 5]);
assert_equals(tensor_size(mop), [3, 5]);
assert_equals(size(mop,1), 3);
assert_equals(size(mop,2), 5);
x = rand(5,2);
assert_equals(apply(mop,x), A*x);
assert_equals(mop*x, A*x);

% Compositions
A2 = rand(4,3);
mop2 = MatrixOperator(A2);
cop = mop2 * mop;

assert_equals(size(cop), [4,5]);
assert_equals(cop*x, A2*(A*x));
assert_equals(asmatrix(cop), A2*A);

% Inversion and solving
A=rand(7) + 3 * eye(7);
x = rand(7,2);
mop = MatrixOperator(A);
assert_equals(solve(mop,x), A\x);
assert_equals(mop\x, A\x);
assert_equals(inv(mop)*x, A\x); %#ok<*MINV>
assert_equals(asmatrix(inv(mop)), inv(A));
assert_equals(asmatrix(inv(inv(mop))), A);

% Inversion and composition (note, that the following works only if the
% null space of A and the null space of B' are identical)
x = rand(7,1);
A=rand(7,8);
B=A'*rand(7,7);

mop1=MatrixOperator(A);
mop2=MatrixOperator(B);
cop = mop1 * mop2;
assert_equals(size(cop), [7, 7]);
assert_equals(asmatrix(cop), A*B);
assert_equals(asmatrix(inv(cop)), inv(A*B));
assert_equals(solve(cop,x), (A*B)\x);
assert_equals(inv(cop)*x, B\(A\x));
