function r = polysys_recur_coeff(syschar, deg, varargin)
% POLYSYS_RECUR_COEFF Compute recurrence coefficient of orthogonal polynomials.
%   R = POLYSYS_RECUR_COEFF(SYSCHAR, DEG) computes the recurrence coefficients for
%   the system of orthogonal polynomials SYSCHAR. The signs are compatible with
%   the ones given in Abramowith & Stegun 22.7:
%
%       p_n+1  = (a_n + x b_n) p_n - c_n p_n-1
%
%   Since matlab indices start at one, we have here the mapping
%
%       r(n,:) = (a_n-1, b_n-1, c_n-1)
%
%   Furthermore the coefficients start here for p_1, so that only p_-1=0
%   and p_0=1 need to be fixed (otherwise p_1, would need to be another
%   parameter, since it's not always equal to x). Therefore there needs to
%   be a little extra treatment for the coefficient of the Chebyshev
%   polynomials of the first kind, esp. T_1).
%
%   Note: Normally you don't want to call this function directly. Call one
%   of the GPC functions instead.
%
% References:
%   [1] Abramowitz & Stegun: Handbook of Mathematical Functions
%   [2] http://dlmf.nist.gov/18.9
%
% Example (<a href="matlab:run_example polysys_recur_coeff">run</a>)
%
% See also GPC

%   Elmar Zander (Jacobi polynomials added by Noemi Friedman)
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

n = (0:deg-1)';
one = ones(size(n));
zero = zeros(size(n));
switch upper(syschar)
    case  'H'
        r = [zero, one, n];
    case 'P'
        r = [zero, (2*n+1)./(n+1), n ./ (n+1)];
    case 'T'
        r = [zero, 2*one - (n==0), one];
    case  'U'
        r = [zero, 2*one, one];
    case 'L'
        r = [(2*n + 1) ./ (n+1),  -1 ./ (n+1), n ./ (n+1)];
    case 'M'
        r = [zero, one, zero];
    otherwise
        polysys = gpc_registry('get', syschar);
        if isempty(polysys)
            error('sglib:gpc:polysys', 'Unknown polynomials system: %s', syschar);
        end
        r = polysys.recur_coeff(deg);
        return
end
 

if syschar == lower(syschar) % lower case signifies normalised polynomials
    z = [0, sqrt(polysys_sqnorm(upper(syschar), 0:deg))]';
    % row n: p_n+1  = (a_n + x b_n) p_n + c_n p_n-1
    %   =>   z_n+1 q_n+1  = (a_n + x b_n) z_n q_n + c_n z_n-1 p_n-1
    %   =>   q_n+1  = (a_n + x b_n) z_n/z_n+1 q_n + c_n z_n-1/z_n+1 p_n-1
    r = [r(:,1) .* z(n+2) ./ z(n+3), ...
         r(:,2) .* z(n+2) ./ z(n+3), ...
         r(:,3) .* z(n+1) ./ z(n+3)];
end
