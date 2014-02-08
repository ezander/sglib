function unittest_integrate_nd
% UNITTEST_INTEGRATE_ND Test the INTEGRATE_ND function.
%
% Example (<a href="matlab:run_example unittest_integrate_nd">run</a>)
%   unittest_integrate_nd
%
% See also INTEGRATE_ND, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'integrate_nd' );

assert_equals( integrate_nd( @scalar_func_2d_vec, @gauss_hermite_rule, 2, 3 ), [1;0;0;1;0;1;0;3], 'default' );
assert_equals( integrate_nd( @scalar_func_2d_vec, @gauss_hermite_rule, 2, 3, 'grid', 'smolyak' ), [1;0;0;1;0;1;0;3], 'smolyak' );
assert_equals( integrate_nd( @scalar_func_2d_vec, @gauss_hermite_rule, 2, 3, 'grid', 'full_tensor' ), [1;0;0;1;0;1;0;3], 'tensor' );

assert_equals( integrate_nd( @scalar_func_2d_novec, @gauss_hermite_rule, 2, 3, 'vectorized', false ), [1;0;0;1;0;1;0;3], 'novec' );
assert_equals( integrate_nd( @scalar_func_2d_novec_trans, @gauss_hermite_rule, 2, 3, 'vectorized', false, 'transposed', true ), [1;0;0;1;0;1;0;3], 'novec_trans' );

assert_equals( integrate_nd( @scalar_func_2d_vec_trans, @gauss_hermite_rule, 2, 3, 'transposed', true ), [1,0,0,1,0,1,0,3], 'trans' );

assert_equals( integrate_nd( @(x)(exp(x(1))), @gauss_hermite_rule, 1, 10, 'vectorized', false ), exp(1/2), 'exp1' );
assert_equals( integrate_nd( @(x)(exp(x(1)+x(2))), @gauss_hermite_rule, 2, 10, 'vectorized', false ), exp(1), 'exp2' );
assert_equals( integrate_nd( @(x)(exp( sum(x,1)/sqrt(3) )), @gauss_hermite_rule, 3, 8, 'vectorized', true ), exp(1/2), 'exp3' );
assert_equals( integrate_nd( @(x)(exp( sum(x,1)/sqrt(3) )), @gauss_hermite_rule, 3, 8, 'vectorized', true, 'grid', 'tensor' ), exp(1/2), 'exp3b' );
assert_equals( integrate_nd( @(x)(exp( sum(x,2)/sqrt(3))), @gauss_hermite_rule, 3, 8, 'vectorized', true, 'transposed', true ), exp(1/2), 'exp3c' );

% check that if the function is empty only the integration rule is returned
x_ex = [-1, 0, 0, 0, 1; 0, -1, 0, 1, 0];
w_ex = [0.5, 0.5, -1, 0.5, 0.5]';
[x,w]=integrate_nd( [], @gauss_hermite_rule, 2, 2 );
assert_equals(x, x_ex, 'rule_x');
assert_equals(w, w_ex, 'rule_w');

xw=integrate_nd( [], @gauss_hermite_rule, 2, 2 );
assert_equals(xw, {x_ex, w_ex}, 'rule_xw');


function res=scalar_func_2d_vec( x )
res=polyfun( x(1,:), x(2,:) );

function res=scalar_func_2d_vec_trans( x )
res=scalar_func_2d_vec( x' )';

function res=scalar_func_2d_novec( x )
res=polyfun( x(1), x(2) );

function res=scalar_func_2d_novec_trans( x )
res=scalar_func_2d_novec( x' )';

function res=polyfun( x, y )
res=[ ones(size(x)); x; y; x.^2; x.*y; y.^2; x.^3; y.^4 ];
