function unittest_gpcbasis_create
% UNITTEST_GPCBASIS_CREATE Test the GPCBASIS_CREATE function.
%
% Example (<a href="matlab:run_example unittest_gpcbasis_create">run</a>)
%   unittest_gpcbasis_create
%
% See also GPCBASIS_CREATE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpcbasis_create' );

% check basis creation when only one polynomials system is specified
V = gpcbasis_create('h', 'm', 3);
assert_equals(V, {'h', [0, 0, 0]}, 'onesys1');

V = gpcbasis_create('p', 'p', 5);
assert_equals(V, {'p', (0:5)'}, 'onesys2');

V = gpcbasis_create('L', 'm', 2, 'p', 6);
assert_equals(V, {'L', multiindex(2,6)}, 'onesys3');


% check basis creation when only multiple polynomials are specified
V = gpcbasis_create('Lph');
assert_equals(V, {'Lph', multiindex(3,0)}, 'polysys1');

V = gpcbasis_create('Lph', 'm', 3);
assert_equals(V, {'Lph', multiindex(3,0)}, 'polysys2');

V = gpcbasis_create('Lph', 'p', 4);
assert_equals(V, {'Lph', multiindex(3,4)}, 'polysys4');

% check error reporting when there is a mismatch between m and syschars
assert_error(funcreate(@gpcbasis_create, 'pppp', 'm', 3), 'sglib:gpc', 'err_no_match');


% check creation of gpc basis from multiindex set
V = gpcbasis_create('h', 'I', multiindex(3, 5));
assert_equals(V, {'h', multiindex(3,5)}, 'I1');

% check creation from existing basis
V0 = gpcbasis_create('Lph');
V = gpcbasis_create(V0, 'p', 4);
assert_equals(V, {'Lph', multiindex(3,4)}, 'polysys4');
