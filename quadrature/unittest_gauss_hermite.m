function unittest_gauss_hermite
% UNITTEST_GAUSS_HERMITE Test the GAUSS_HERMITE function.
%
% Example (<a href="matlab:run_example unittest_gauss_hermite">run</a>)
%    unittest_gauss_hermite
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'gauss_hermite' );

assert_equals( gauss_hermite({@uplus},2), 0, 'ident' );

% Calculate integral of monomials with Gaussian weighting function. The
% result for x^i should be 0 for odd i and (i-1)!! for even i where
% n!!=1x3x5x...xn.
expect=@(n)( mod(n-1,2)*prod(1:2:(n-1)) );
for i=0:10
    f={@power,{i},{2}};
    p=ceil((i+1)/2);
    assert_equals( gauss_hermite(f,p), expect(i), sprintf('order_%d',i) );
end

% The integral of exp(ax) w.r.t. gaussian measure exp(-x^2/2) can be evaluated 
% analytically to be exp(+a^2/2), since (x-a)^2/2=x^2/2-ax+a^2/2
assert_equals( gauss_hermite(@(x)(exp(-x)),8), exp(1/2), 'neg_x' );
assert_equals( gauss_hermite(@(x)(exp(x)),8), exp(1/2), 'x' );
assert_equals( gauss_hermite(@(x)(exp(-pi*x)),18), exp(pi*pi/2), 'pi_x' );

% Since the exp(ix)=i sin(x)=cos(x) from the preceding we immediately get
assert_equals( gauss_hermite(@sin,2), 0, 'sin' );
assert_equals( gauss_hermite(@cos,8), exp(-1/2), 'cos' );


