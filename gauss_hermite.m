function int=gauss_hermite( func, p )
% GAUSS_HERMITE Numerically integrate with Gauss-Hermite quadrature rule.
%   INT=GAUSS_HERMITE( F, P ) approximates the integral
%     $$ \int_{-\infty}^\infty F(x) exp(-x^2/2)/sqrt(2\pi) dx $$
%   by Gauss-Hermite quadrature of order 2*p. The weights and quadrature
%   points are calculated on the fly but stored in a persistent array for
%   later use. The precision of the coefficients has still to be assessed.
% 
% Note: 
%   F has to be vectorized. Thus instead of @(x)(x*x) write @(x)(x.*x).
%
% Example (<a href="matlab:run_example gauss_hermite">run</a>)
%   int=gauss_hermite( @(x)(ones(size(x))), 4 ); % => 1
%   int=gauss_hermite( @(x)(x.*x), 4 ); % => 1
%   int=gauss_hermite( @exp, 3 );
% 
% See also GAUSS_HERMITE_RULE, GAUSS_HERMITE_MULTI

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin==0
    func=@exp;
    p=4;
end

[x,w]=gauss_hermite_rule(p);

int=sum(w.*funcall(func,x));
