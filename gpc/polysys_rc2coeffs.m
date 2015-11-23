function p=polysys_rc2coeffs(r)
% POLYSYS_RC2COEFFS Generate polynomial coefficients from recurrence.
%   P = POLYSYS_RC2COEFFS(R) generates the polynomial coefficients from the
%   recurrence coefficients given in R.
%
%   Note: Don't use this for evaluating polynomials as this is unstable and
%   numerically not accurate. It's only meant as a helper to see what the
%   polynomial coefficients are. If you want to evaluate polynomials use
%   GPC_EVALUATE instead.
%
% Example (<a href="matlab:run_example polysys_rc2coeffs">run</a>)
%   for syschar = 'HPLTUM'
%     underline(['Polynomials: ' syschar]);
%     r = polysys_recur_coeff(syschar, 5);
%     p = polysys_rc2coeffs(r);
%     for i = 1:size(p,1)
%       fprintf('%s_%d(x) = %s\n', syschar, i-1, format_poly(p(i,:), 'rats', true));
%     end
%     fprintf('\n');
%   end
%
% See also GPC_EVALUATE, POLYSYS_RECUR_COEFF

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

n = size(r,1) + 1;
p = [zeros(1, n);
    zeros(1, n-1), 1];

for k=1:n-1
    p(k+2,:) = r(k,2) * [p(k+1,2:end), 0] + r(k,1) * p(k+1,:) - r(k,3) * p(k,:);
end
p = p(2:end,:);
