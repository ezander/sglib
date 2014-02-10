function unittest_gauss_legendre_triangle_rule
% UNITTEST_GAUSS_LEGENDRE_TRIANGLE_RULE Test the GAUSS_LEGENDRE_TRIANGLE_RULE function.
%
% Example (<a href="matlab:run_example unittest_gauss_legendre_triangle_rule">run</a>)
%   unittest_gauss_legendre_triangle_rule
%
% See also GAUSS_LEGENDRE_TRIANGLE_RULE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gauss_legendre_triangle_rule' );

% Test for two different p values (should be enough)
for p=[2,5];
    [x,w]=gauss_legendre_triangle_rule(p);
    assert_equals( size(x,1), 2, 'x_dim2' )
    assert_equals( size(w,2), 1, 'w_column' )
    assert_equals( sum(w), 1/2, 'area_tri' )
    assert_equals( x*w, [1/6; 1/6], 'linear' )
end

munit_set_function( 'gauss_legendre_triangle_rule' );

% Test for polynomilas up some specified order
[A,B,I]=testGaussTriangle(2);
assert_equals(A(I), B(I), 'poly_int_tri_2' );
[A,B,I]=testGaussTriangle(5);
assert_equals(A(I), B(I), 'poly_int_tri_5' );




function [A,B,I]=testGaussTriangle(p)
% On exit A(j,k) contains \int_Triangle x^j y^k computed by the quadrature
% rule, while B containes the same computed by an analytical formula. The
% matrix I indicates on which entries the formula must yield exact results.
% That mean A(I)==I
[x,w]=gauss_legendre_triangle_rule(p);
N=2*p;
A=zeros(N+1);
B=zeros(N+1);
I=false(N+1);
for l=0:N;
    for k=0:N;
        A(l+1,k+1)=x(1,:).^l.*x(2,:).^k*w;
        B(l+1,k+1)=prod((1:l)./((k+1):(k+l)))/((k+l+1)*(k+l+2));
        I(l+1,k+1)=(l+k<=2*p-2);
    end;
end;


