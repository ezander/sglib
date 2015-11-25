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

% First reset the registry to its default state
gpc_registry('reset');

% ... check that the entry for 'x' is empty
xpolys = gpc_registry('get', 'x');
assert_equals(xpolys, [], 'x_empty');

% ... put the jacobis at 'x' and check
polys = JacobiPolynomials(2,3);
gpc_registry('set', 'x', polys);
[xpolys, dist] = gpc_registry('get', 'x');
assert_equals(xpolys, polys, 'x_jac');
assert_equals(dist, polys.weighting_dist(), 'x_dist');

% ... put the jacobis again at 'x' should be ok
polys = JacobiPolynomials(2,3);
gpc_registry('set', 'x', polys);

% ... putting other polys at 'x' should not work
assert_error(funcreate(@gpc_registry, 'set', 'x', HermitePolynomials()), ...
    'sglib:', 'same_polys_only');

% ... unknown action triggers error
assert_error(funcreate(@gpc_registry, 'xxxyyy'), 'sglib:', 'unknown_action');

% ... get all and resetting
[reg,charind]=gpc_registry('getall');
assert_equals(reg([]), struct('syschar',{}, 'polysys', {}, 'dist', {}), 'reg_struct');

gpc_registry('reset');
assert_equals(gpc_registry('get', 'x'), [], 'x_empty2');
gpc_registry('reset', reg);
assert_equals(gpc_registry('get', 'x'), polys, 'x_jac2');

% ... finding indices by polynomial
polys = JacobiPolynomials(2,3);
gpc_registry('reset');
assert_equals(gpc_registry('find', HermitePolynomials()), 'H', 'find_H');
assert_equals(gpc_registry('find', LegendrePolynomials().normalized()), 'p', 'find_p');
assert_equals(gpc_registry('find', polys), '', 'find_j1');
gpc_registry('set', 'x', polys);
assert_equals(gpc_registry('find', polys), 'x', 'find_j2');
gpc_registry('set', 'x', polys);

% ... finding free indices
assert_equals(gpc_registry('findfree', 'hpxjo'), 'j', 'findfree_j');
assert_equals(gpc_registry('findfree', 'hpx'), 'a', 'findfree_a');
gpc_registry('set', 'j', polys);
gpc_registry('set', 'a', polys);
assert_equals(gpc_registry('findfree', 'hpxjo'), 'o', 'findfree_j');
assert_equals(gpc_registry('findfree', 'hpx'), 'b', 'findfree_a');
