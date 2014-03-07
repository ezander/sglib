function unittest_TensorOperator
% UNITTEST_TENSOROPERATOR Test the TENSOROPERATOR function.
%
% Example (<a href="matlab:run_example unittest_TensorOperator">run</a>)
%   unittest_TensorOperator
%
% See also TENSOROPERATOR, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'TensorOperator' );

A1 = rand(5,4);
B1 = rand(3,7);
x = rand(4, 7);

top1 = TensorOperator({A1, B1});
assert_equals(size(top1), [15, 28]);
assert_equals(size(top1, 1), [15]);
assert_equals(size(top1, [2], false), [4;7]);

assert_equals(asmatrix(top1), revkron(A1, B1));
assert_equals(top1*x, A1*x*B1');


C1 = rand(7,5);
D1 = rand(9,3);

top2 = TensorOperator({C1, D1});
top = top2 * top1;
assert_equals(size(top), [63, 28]);
assert_equals(size(top, 1, false), [7;9]);
assert_equals(size(top, 2, false), [4;7]);

assert_equals(asmatrix(top), asmatrix(top2)*asmatrix(top1));
