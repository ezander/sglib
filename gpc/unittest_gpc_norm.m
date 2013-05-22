function unittest_gpc_norm
% UNITTEST_GPC_NORM Test the GPC_NORM function.
%
% Example (<a href="matlab:run_example unittest_gpc_norm">run</a>)
%   unittest_gpc_norm
%
% See also GPC_NORM, TESTSUITE 

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpc_norm' );


assert_equals(gpc_norm({'H', [1, 1, 1]}), 1);
assert_equals(gpc_norm({'H', [1; 1; 1]}), [1;1;1]);


I = multiindex(2, 3);
V = {'P', I};
assert_equals(gpc_norm(V).^2, 1./[1,3,3,5,9,5,7,15,15,7]');

V = {'p', I};
assert_equals(gpc_norm(V).^2, ones(10,1));

V = {'H', I};
assert_equals(gpc_norm(V).^2, [1,1,1,2,1,2,6,2,2,6]');

V = {'h', I};
assert_equals(gpc_norm(V).^2, ones(10,1));

% Later
V = {'PPHH', [I, I]};
assert_equals(gpc_norm(V).^2, (1./[1,3,3,5,9,5,7,15,15,7] .* [1,1,1,2,1,2,6,2,2,6])');

% check options
I = multiindex(2, 3);
V = {'P', I};
assert_equals(gpc_norm(V, 'sqrt', true), sqrt(1./[1,3,3,5,9,5,7,15,15,7]'));
assert_equals(gpc_norm(V, 'sqrt', false), 1./[1,3,3,5,9,5,7,15,15,7]');
