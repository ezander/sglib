function unittest_integrate_1d
% UNITTEST_INTEGRATE_1D Test the INTEGRATE_1D function.
%
% Example (<a href="matlab:run_example unittest_integrate_1d">run</a>)
%   unittest_integrate_1d
%
% See also INTEGRATE_1D, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'integrate_1d' );

identity=@uplus;
assert_equals( integrate_1d( identity, @gauss_hermite_rule, 3 ), 0, 'uplus' );
assert_equals( integrate_1d( @scalar_func_1d, @gauss_hermite_rule, 3 ), 1, 'one' );
assert_equals( integrate_1d( {@scalar_func_1d}, @gauss_hermite_rule, 3 ), 1, 'one_2' );

assert_equals( integrate_1d( @vector_func, @gauss_hermite_rule, 3 ), [1;0;1;0;3], 'vec' );
assert_equals( integrate_1d( @vector_func_novec, @gauss_hermite_rule, 3, 'vectorized', false ), [1;0;1;0;3], 'novec' );
assert_equals( integrate_1d( @vector_func_trans, @gauss_hermite_rule, 3, 'transposed', true ), [1;0;1;0;3]', 'transposed' );
assert_equals( integrate_1d( @vector_func_trans, @gauss_hermite_rule, 3, 'vectorized', false, 'transposed', true ), [1;0;1;0;3]', 'novec_trans' );

% The example from the comments section
n=(0:6)';
int =integrate_1d( {@all_powers, {n}, {2}}, @gauss_hermite_rule, 4 );
assert_equals( round(int), [1;0;1;0;3;0;15], 'example' );

% The example from the comments section
n=(0:6)';
int =integrate_1d( {@all_powers, {n}, {2}}, @gauss_legendre_rule, 8 );
assert_equals( int, (1-(-1).^(n+1))./(n+1), 'example2' );


function pow=all_powers( x, n )
pow=binfun(@power, x, n);

function res=scalar_func_1d( x )
res=ones(size(x));

function res=vector_func( x )
res=[ones(size(x)); x; x.^2; x.^3; x.^4];

function res=vector_func_novec( x )
res=[1; x; x^2; x^3; x^4];

function res=vector_func_trans( x )
res=[ones(size(x)), x, x.^2, x.^3, x.^4];

