function [x,w]=polysys_int_rule(sys, n, varargin)
% POLYSYS_INT_RULE Short description of polysys_int_rule.
%   POLYSYS_INT_RULE Long description of polysys_int_rule.
%
% Example (<a href="matlab:run_example polysys_int_rule">run</a>)
%
% See also

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

[x,w]=gauss_rule(sys, n, varargin);

function [x,w]=gauss_rule(sys, n, varargin)
% WALTER GAUTSCHI
% ORTHOGONAL POLYNOMIALS AND QUADRATURE
% Electronic Transactions on Numerical Analysis.
% Volume 9, 1999, pp. 65-76.

r = polysys_recur_coeff(sys, n);

% extract columns
a = r(:,1);
b = r(2:end,3);

% convert to monic polynomials
c = r(:,2);
a = a ./ c;
b = b ./ (c(1:end-1) .* c(2:end));
sb = sqrt(b);

% set up Jacobi matrix and compute eigenvalues
J = diag(a) + diag(sb,1) + diag(sb,-1);
[V,D] = eig(J);
x = diag(D);
w = V(1,:).^2;
w = w / sum(w);

% symmetrise
xr=x(end:-1:1);
wr=w(end:-1:1);
if norm(x+xr)<1e-10
    x=0.5*(x-xr);
    w=0.5*(w+wr);
end

% compute the weights


function [x,w]=gauss_lobatto_rule(sys, n, varargin)
function [x,w]=gauss_kronrod_rule(sys, n, varargin)
