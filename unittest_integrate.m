function unittest_integrate
% UNITTEST_INTEGRATE Test the INTEGRATE function.
%
% Example (<a href="matlab:run_example unittest_integrate">run</a>)
%   unittest_integrate
%
% See also INTEGRATE, TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

assert_set_function( 'integrate' );

assert_equals( integrate( @scalar_func_2d_vec, @gauss_hermite_rule, 2, 3 ), [1;0;0;1;0;1;0;3], 'default' );
assert_equals( integrate( @scalar_func_2d_vec, @gauss_hermite_rule, 2, 3, 'grid', 'smolyak' ), [1;0;0;1;0;1;0;3], 'smolyak' );
assert_equals( integrate( @scalar_func_2d_vec, @gauss_hermite_rule, 2, 3, 'grid', 'full_tensor' ), [1;0;0;1;0;1;0;3], 'tensor' );

assert_equals( integrate( @scalar_func_2d_novec, @gauss_hermite_rule, 2, 3, 'vectorized', false ), [1;0;0;1;0;1;0;3], 'novec' );
assert_equals( integrate( @scalar_func_2d_novec_trans, @gauss_hermite_rule, 2, 3, 'vectorized', false, 'transposed', true ), [1;0;0;1;0;1;0;3], 'novec_trans' );

assert_equals( integrate( @scalar_func_2d_vec_trans, @gauss_hermite_rule, 2, 3, 'transposed', true ), [1,0,0,1,0,1,0,3], 'trans' );

assert_equals( integrate( @(x)(exp(x(1))), @gauss_hermite_rule, 1, 10, 'vectorized', false ), exp(1/2), 'exp1' );
assert_equals( integrate( @(x)(exp(x(1)+x(2))), @gauss_hermite_rule, 2, 10, 'vectorized', false ), exp(1), 'exp2' );
assert_equals( integrate( @(x)(exp( sum(x,1)/sqrt(3) )), @gauss_hermite_rule, 3, 8, 'vectorized', true ), exp(1/2), 'exp3' );
assert_equals( integrate( @(x)(exp( sum(x,1)/sqrt(3) )), @gauss_hermite_rule, 3, 8, 'vectorized', true, 'grid', 'tensor' ), exp(1/2), 'exp3b' );
assert_equals( integrate( @(x)(exp( sum(x,2)/sqrt(3))), @gauss_hermite_rule, 3, 8, 'vectorized', true, 'transposed', true ), exp(1/2), 'exp3c' );



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



function foobar
if 0
    % Calculate integral of monomials with Gaussian weighting function. The
    % result for x^i should be 0 for odd i and (i-1)!! for even i where
    % n!!=1x3x5x...xn.
    expect=@(n)( mod(n-1,2)*prod(1:2:(n-1)) );

    % Testing multidimension gauss hermite quadrature
    % (Since the integrand simply factors the results should be the same as the
    % products of the single integrations.)
    clear a b
    a=zeros(5,5);
    b=a;
    for i=0:4;
        for j=0:4;
            f3=@(x,i,j)(x(1)^i*x(2)^j);
            f={f3,{i,j},{2,3}};
            a(i+1,j+1)=gauss_hermite_multi( f, 2, 4 );
            b(i+1,j+1)=expect(i)*expect(j);
        end;
    end;
    assert_equals( a, b, 'gauss_hermite_multi' );

    % This should give e
end


