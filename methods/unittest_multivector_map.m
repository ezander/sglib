function unittest_multivector_map(varargin)
% UNITTEST_MULTIVECTOR_MAP Test the MULTIVECTOR_MAP function.
%
% Example (<a href="matlab:run_example unittest_multivector_map">run</a>)
%   unittest_multivector_map
%
% See also MULTIVECTOR_MAP, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'multivector_map' );

%% Scalar test
v = multivector_init(5, 4) + rand(5,4);
[l1,l2] = multivector_map(@norms, v);
assert_equals(l1, norm(v,1), 'scalar1');
assert_equals(l2, norm(v,2), 'scalar2');

%% Cell array test
v = {rand(5,4), rand(7,4)};
[l1,l2,linf] = multivector_map(@norms, v);
assert_equals(l1{1}, norm(v{1},1), 'struct_foo1');
assert_equals(l1{2}, norm(v{2},1), 'struct_bar1');
assert_equals(l2{1}, norm(v{1},2), 'struct_foo2');
assert_equals(linf{2}, norm(v{2},inf), 'struct_bar_inf');

%% Struct test
v = struct('foo', rand(5,4), 'bar', rand(7,4));
[l1,l2,linf] = multivector_map(@norms, v);
assert_equals(l1.foo, norm(v.foo,1), 'struct_foo1');
assert_equals(l1.bar, norm(v.bar,1), 'struct_bar1');
assert_equals(l2.foo, norm(v.foo,2), 'struct_foo2');
assert_equals(linf.bar, norm(v.bar,inf), 'struct_bar_inf');

%% Struct test
v = {rand(2,4), struct('foo', {{rand(5,4), rand(3,4)}}, 'bar', rand(7,4))};
p=1; lex1 = {norm(v{1},p), struct('foo', {{norm(v{2}.foo{1},p), norm(v{2}.foo{2},p)}}, 'bar', norm(v{2}.bar,p))};
p=2; lex2 = {norm(v{1},p), struct('foo', {{norm(v{2}.foo{1},p), norm(v{2}.foo{2},p)}}, 'bar', norm(v{2}.bar,p))};
p=inf; lexinf = {norm(v{1},p), struct('foo', {{norm(v{2}.foo{1},p), norm(v{2}.foo{2},p)}}, 'bar', norm(v{2}.bar,p))};

[l1,l2,linf] = multivector_map(@norms, v);
assert_equals(l1, lex1, 'rec_1');
assert_equals(l2, lex2, 'rec_2');
assert_equals(linf, lexinf, 'rec_inf');



function [l1, l2, linf] = norms(A)
l1 = norm(A, 1);
l2 = norm(A, 2);
linf = norm(A, inf);
