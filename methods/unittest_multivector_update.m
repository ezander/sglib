function unittest_multivector_update(varargin)
% UNITTEST_MULTIVECTOR_UPDATE Test the MULTIVECTOR_UPDATE function.
%
% Example (<a href="matlab:run_example unittest_multivector_update">run</a>)
%   unittest_multivector_update
%
% See also MULTIVECTOR_UPDATE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'multivector_update' );

%% Scalar test
a = rand(1); 
u = rand(5,2);
B = rand(2,4);

v0 = multivector_init(5, 4) + rand(5,4);
v=multivector_update(v0, a, u, B);

assert_equals(v, v0 + a * u * B, 'scalar');

%% Cell array test
a = rand(1); 
u = {rand(3,2), rand(6,2)};
B = rand(2,4);

v0 = {rand(3,4), rand(6,4)};
v=multivector_update(v0, a, u, B);

assert_equals(v, {v0{1} + a * u{1} * B, v0{2} + a * u{2} * B}, 'cell');


%% Struct array test
a = rand(1); 
u = struct();
u.foo = rand(3,2);
u.bar = rand(6,2);
B = rand(2,4);

v0 = struct();
v0.foo = rand(3,4);
v0.bar = rand(6,4);
v=multivector_update(v0, a, u, B);

res = struct();
res.foo = v0.foo + a * u.foo * B;
res.bar = v0.bar + a * u.bar * B;
assert_equals(v, res, 'struct');
