function unittest_gpc_registry(varargin)
% UNITTEST_GPC_REGISTRY Test the GPC_REGISTRY function.
%
% Example (<a href="matlab:run_example unittest_gpc_registry">run</a>)
%   unittest_gpc_registry
%
% See also GPC_REGISTRY, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpc_registry' );

gpc_registry('reset');

xpolys = gpc_registry('get', 'x');
assert_equals(xpolys, [], 'x_empty');

gpc_registry('set', 'x', JacobiPolynomials(2,3));
[xpolys, dist] = gpc_registry('get', 'x');
assert_equals(xpolys, JacobiPolynomials(2,3), 'x_jac');


