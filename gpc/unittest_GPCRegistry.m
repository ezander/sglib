function unittest_GPCRegistry(varargin)
% UNITTEST_GPCREGISTRY Test the GPCREGISTRY function.
%
% Example (<a href="matlab:run_example unittest_GPCRegistry">run</a>)
%   unittest_GPCRegistry
%
% See also GPCREGISTRY, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'GPCRegistry' );



% Construct a new registry
gpcreg = GPCRegistry;

% ... check that the entry for 'x' is empty
xpolys = gpcreg.get('x');
assert_equals(xpolys, [], 'x_empty');

% ... put the jacobis at 'x' and check
polys = JacobiPolynomials(2,3);
gpcreg.set('x', polys);
[xpolys, dist] = gpcreg.get('x');
assert_equals(xpolys, polys, 'x_jac');
assert_equals(dist, polys.weighting_dist(), 'x_dist');

% ... put the jacobis again at 'x' should be ok
polys = JacobiPolynomials(2,3);
gpcreg.set('x', polys);

% ... putting other polys at 'x' should not work
assert_error(funcreate(@set, gpcreg, 'x', HermitePolynomials()), ...
    'sglib:', 'same_polys_only');

% ... get all and resetting
[reg,charind]=gpcreg.getall();
assert_equals(reg([]), struct('syschar',{}, 'polysys', {}, 'dist', {}), 'reg_struct');

gpcreg.reset();
assert_equals(gpcreg.get('x'), [], 'x_empty2');
gpcreg.reset(reg);
assert_equals(gpcreg.get('x'), polys, 'x_jac2');

