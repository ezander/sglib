function unittest_gpcbasis_norm
% UNITTEST_GPCBASIS_NORM Test the GPCBASIS_NORM function.
%
% Example (<a href="matlab:run_example unittest_gpcbasis_norm">run</a>)
%   unittest_gpcbasis_norm
%
% See also GPCBASIS_NORM, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpcbasis_norm' );


assert_equals(gpcbasis_norm({'H', [1, 1, 1]}), 1);
assert_equals(gpcbasis_norm({'H', [1; 1; 1]}), [1;1;1]);


I = multiindex(2, 3);
V = {'P', I};
assert_equals(gpcbasis_norm(V).^2, 1./[1,3,3,5,9,5,7,15,15,7]');

V = {'p', I};
assert_equals(gpcbasis_norm(V).^2, ones(10,1));

V = {'H', I};
assert_equals(gpcbasis_norm(V).^2, [1,1,1,2,1,2,6,2,2,6]');

V = {'h', I};
assert_equals(gpcbasis_norm(V).^2, ones(10,1));

% Later
V = {'PPHH', [I, I]};
assert_equals(gpcbasis_norm(V).^2, (1./[1,3,3,5,9,5,7,15,15,7] .* [1,1,1,2,1,2,6,2,2,6])');

% check options
I = multiindex(2, 3);
V = {'P', I};
assert_equals(gpcbasis_norm(V, 'sqrt', true), sqrt(1./[1,3,3,5,9,5,7,15,15,7]'));
assert_equals(gpcbasis_norm(V, 'sqrt', false), 1./[1,3,3,5,9,5,7,15,15,7]');
