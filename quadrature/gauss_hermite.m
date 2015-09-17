function int=gauss_hermite( func, p )
% GAUSS_HERMITE Numerically integrate with Gauss-Hermite quadrature rule.
%   INT=GAUSS_HERMITE( F, P ) approximates the integral
%     $$ \int_{-\infty}^\infty F(x) exp(-x^2/2)/sqrt(2\pi) dx $$
%   by Gauss-Hermite quadrature of order 2*p. The weights and quadrature
%   points are calculated on the fly but stored in a persistent array for
%   later use. The precision of the coefficients has still to be assessed.
%
% Note 1:
%   FUNC has to be vectorized. Thus instead of @(x)(x*x) write @(x)(x.*x).
% Note 2:
%   This function is more or less obsolete since INTEGRATE_1D or the GPC
%   integration methods are more general and not more difficult to use.
%   This function will probably be removed in one of the next versions.
%
% Example (<a href="matlab:run_example gauss_hermite">run</a>)
%   fprintf( 'the following should print: %g %g %g\n', 1, 1, exp(.5) );
%   int=gauss_hermite( @(x)(ones(size(x))), 4 ) % => 1
%   int=gauss_hermite( @(x)(x.*x), 4 ) % => 1
%   int=gauss_hermite( @exp, 3 ) % => exp(.5)
%
% See also GAUSS_HERMITE_RULE, INTEGRATE_1D, GPC_INTEGRATE

%   Elmar Zander
%   Copyright 2006-2014, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

int=integrate_1d( func, @gauss_hermite_rule, p );
