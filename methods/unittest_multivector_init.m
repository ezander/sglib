function unittest_multivector_init(varargin)
% UNITTEST_MULTIVECTOR_INIT Test the MULTIVECTOR_INIT function.
%
% Example (<a href="matlab:run_example unittest_multivector_init">run</a>)
%   unittest_multivector_init
%
% See also MULTIVECTOR_INIT, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'multivector_init' );

assert_equals(multivector_init(2, 3), zeros(2,3), 'scalar');
assert_equals(multivector_init({2,4,5}, 3), {zeros(2,3), zeros(4,3), zeros(5,3)}, 'cell');
assert_equals(multivector_init(struct('foo', 6, 'bar', 8), 3), struct('foo', zeros(6,3), 'bar', zeros(8,3)), 'struct');

assert_equals(multivector_init({2, struct('foo', {{6, 3}}, 'bar', 8)}, 3), ...
    {zeros(2,3), struct('foo', {{zeros(6,3), zeros(3,3)}}, 'bar', zeros(8,3))}, 'recursive');
