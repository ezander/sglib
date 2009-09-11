function unittest_gauss_hermite
% UNITTEST_GAUSS_HERMITE Test the GAUSS_HERMITE function.
%
% Example (<a href="matlab:run_example unittest_gauss_hermite">run</a>)
%    unittest_gauss_hermite
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'gauss_hermite' );

% Calculate integral of monomials with Gaussian weighting function. The
% result for x^i should be 0 for odd i and (i-1)!! for even i where
% n!!=1x3x5x...xn.
expect=@(n)( mod(n-1,2)*prod(1:2:(n-1)) );

for i=0:10
    f={@power,{i},{2}};
    p=ceil((i+1)/2);
    assert_equals( gauss_hermite(f,p), expect(i), sprintf('order_%d',i) );
end

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
int=gauss_hermite_multi( @(x)(exp(x(1)+x(2))), 2, 6);
assert_equals( int, exp(1), 'gauss_hermite_multi', struct('abstol', 1e-5) );

