function unittest_gpc_integrate
% UNITTEST_GPC_INTEGRATE Test the GPC_INTEGRATE function.
%
% Example (<a href="matlab:run_example unittest_gpc_integrate">run</a>)
%   unittest_gpc_integrate
%
% See also GPC_INTEGRATE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpc_integrate' );

V = {'H', multiindex(2,0)};
assert_equals( gpc_integrate(@scalar_func_2d_vec, V, 3), [1;0;0;1;0;1;0;3], 'default' );
assert_equals( gpc_integrate(@scalar_func_2d_vec, V, 3, 'grid', 'smolyak'), [1;0;0;1;0;1;0;3], 'smolyak' );
assert_equals( gpc_integrate(@scalar_func_2d_vec, V, 3, 'grid', 'full_tensor'), [1;0;0;1;0;1;0;3], 'tensor' );


% test wether correct nodes and weights are returned
[xs, ws] = smolyak_grid(4, 3, @gauss_hermite_rule);
xw = gpc_integrate([], {'H', [0,0,0,0]}, 3, 'grid', 'smolyak');
assert_equals(xw, {xs, ws}, 'gh_nodes_weights');
[x,w] = gpc_integrate([], {'H', [0,0,0,0]}, 3, 'grid', 'smolyak');
assert_equals(x, xs, 'gh_nodes');
assert_equals(w, ws, 'gh_weights');

% test with nodes when gpc_coeffs are specified
p_i_alpha = [1, 2, 3, 4, 5];
[x,w] = gpc_integrate([], {'H', multiindex(4,1)}, 3, 'grid', 'smolyak', 'gpc_coeffs', p_i_alpha);
assert_equals(x, 1 + [2,3,4,5] * xs, 'gpc_nodes');
assert_equals(sum(w), 1, 'gpc_weights_sum');


V = {'H', multiindex(2,0)};
assert_equals( gpc_integrate( @scalar_func_2d_novec, V, 3, 'vectorized', false ), [1;0;0;1;0;1;0;3], 'novec' );
assert_equals( gpc_integrate( @scalar_func_2d_novec_trans, V, 3, 'vectorized', false, 'transposed', true ), [1;0;0;1;0;1;0;3], 'novec_trans' );

assert_equals( gpc_integrate( @scalar_func_2d_vec_trans, V, 3, 'transposed', true ), [1,0,0,1,0,1,0,3], 'trans' );

assert_equals( gpc_integrate( @(x)(exp(x(1))), {'H', 0}, 10, 'vectorized', false ), exp(1/2), 'exp1' );
assert_equals( gpc_integrate( @(x)(exp(x(1)+x(2))), {'H', [0, 0]}, 10, 'vectorized', false ), exp(1), 'exp2' );
assert_equals( gpc_integrate( @(x)(exp( sum(x,1)/sqrt(3) )), {'H', [0, 0, 0]}, 8, 'vectorized', true ), exp(1/2), 'exp3' );
assert_equals( gpc_integrate( @(x)(exp( sum(x,1)/sqrt(3) )), {'H', [0, 0, 0]}, 8, 'vectorized', true, 'grid', 'tensor' ), exp(1/2), 'exp3b' );
assert_equals( gpc_integrate( @(x)(exp( sum(x,2)/sqrt(3))), {'H', [0, 0, 0]}, 8, 'vectorized', true, 'transposed', true ), exp(1/2), 'exp3c' );



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

