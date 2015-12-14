function [x,w]=polysys_int_rule(syschar, n,  method)
% POLYSYS_INT_RULE Compute the integration rule for a given system of polynomials.
%   [X,W]=POLYSYS_INT_RULE(SYSCHAR, N, DUST_PARMA, VARARGIN) computes the integration rule
%   with N points for the given system of orthogonal polynomials specified
%   in SYSCHAR and the related probability measure.
%
% Example (<a href="matlab:run_example polysys_int_rule">run</a>)
%   % 5 Point Gauss Hermite rule
%   [x,w]=polysys_int_rule('h', 5)
%
% References
%   [1] W. Gautschi, Orthogonal Polynomials and Quadrature, Electronic
%       Transactions on Numerical Analysis. Volume 9, 1999, pp. 65-76.
%
% See also POLYSYS_RECUR_COEFF

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<3
    method = 'gauss';
end

switch method
    case 'gauss'
        [x,w]=gauss_rule(syschar, n);
    case 'ccf1'
        [x,w]=nested_ccf_rule(syschar, n, 1);
    case {'ccf', 'ccf2'}
        [x,w]=nested_ccf_rule(syschar, n, 2);
    case {'gkp'}
        error('sglib:notstable', 'not stable yet, do not use');
        [x,w]=nested_gauss_patterson(syschar, n);
    otherwise
        error('sglib:polysys_int_rule', 'Unknown method: %s', method);
end

function [x,w]=gauss_rule(syschar, n)
% W. GAUTSCHI, ORTHOGONAL POLYNOMIALS AND QUADRATURE, Electronic
% Transactions on Numerical Analysis, Volume 9, 1999, pp. 65-76.

r = polysys_recur_coeff(syschar, n);

% extract columns
a = -r(:,1);
b = r(2:end,3);
c = r(:,2);

% convert to monic polynomials
a = a ./ c;
if n>1
    b = b ./ (c(1:end-1) .* c(2:end));
    sb = sqrt(b);
else
    sb = zeros(0,1);
end

% set up Jacobi matrix and compute eigenvalues
J = diag(a) + diag(sb,1) + diag(sb,-1);
[V,D] = eig(J);
x = diag(D)';
w = V(1,:)'.^2;
w = w / sum(w);

% symmetrise
xr=x(end:-1:1);
wr=w(end:-1:1);
if norm(x+xr)<1e-10
    x=0.5*(x-xr);
    w=0.5*(w+wr);
end

% compute the weights
%function [x,w]=gauss_lobatto_rule(syschar, n, varargin)
%function [x,w]=gauss_kronrod_rule(syschar, n, varargin)


function [x,w]=nested_ccf_rule(syschar, n, fejern)

dist = polysys_dist(syschar);
domain = gendist_invcdf([0, 1], dist);
if any(isinf(domain)) || any(isinf(gendist_pdf(domain, dist)))
    if fejern==1
        mode = 'fejer1';
    else
        mode = 'fejer2';
    end
else
    mode = 'cc';
end
[x,w] = clenshaw_curtis_nested(n, 'mode', mode, 'interval', [0, 1]);
x = gendist_invcdf(x, dist);


function [x,w]=nested_gauss_patterson(syschar, n, n0)
if nargin<3
    n0 = 1;
end

[x,w]=gauss_rule(syschar, n0);
for k=2:n
    [x,w]=polysys_patterson_extend(syschar, x);
end
