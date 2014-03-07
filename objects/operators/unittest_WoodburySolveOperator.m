function unittest_WoodburySolveOperator
% UNITTEST_WOODBURYSOLVEOPERATOR Test the WOODBURYSOLVEOPERATOR function.
%
% Example (<a href="matlab:run_example unittest_WoodburySolveOperator">run</a>)
%   unittest_WoodburySolveOperator
%
% See also WOODBURYSOLVEOPERATOR, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'WoodburySolveOperator' );

A = rand(5);
wsop = WoodburySolveOperator(MatrixOperator(A));

x = rand(5,2);
assert_equals(wsop*x, A*x);
assert_equals(size(wsop), [5, 5]);
assert_equals(asmatrix(wsop), A);

u = rand(5,2);
v = rand(5,2);
wsop=wsop.update(u,v);
assert_equals(wsop*x, (A+u*v')*x)
assert_equals(asmatrix(wsop), A+u*v')
assert_equals(wsop\x, (A+u*v')\x)
