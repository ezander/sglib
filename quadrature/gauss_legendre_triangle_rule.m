function [x,w]=gauss_legendre_triangle_rule(p)
% GAUSS_LEGENDRE_TRIANGLE_RULE Gauss quadrature over canonical triangle.
%   [X,W]=GAUSS_LEGENDRE_TRIANGLE_RULE(P) returns nodes and weights for
%   quadrature over the canonical triangle with nodes (0,0), (0,1) and
%   (1,0). The integration points are formed by taking the tensor product
%   of two Gauss-Legendre rules with P points and transforming this to the
%   triangle (so, in fact, it's not really a Gauss rule on the triangle,
%   but it integrates exactly polynomials up to total degree 2p-2).
%
% Note: This is may not be the most efficient integration rule on the
%   triangle, however for the problem at hand it suffices.
%
% Example (<a href="matlab:run_example gauss_legendre_triangle_rule">run</a>)
%   [x, w] = gauss_legendre_triangle_rule(7);
%   plot(x(1,:), x(2,:), 'rx'); axis equal;
%   line([0,0,1,0,nan], [0,1,0,0,nan]);
%
% See also GAUSS_LEGENDRE_RULE

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

[x0,w0]=gauss_legendre_rule(p);
w0 = 0.5 * w0;
x0 = 0.5 * (1+x0);

n=length(x0);
x1 = reshape(ones(n,1) * x0, 1, n*n);
x2 = reshape(x0' * (1-x0), 1, n*n);
x = [x1; x2];
w = reshape(w0  * (w0' .* (1-x0)), n*n, 1);
