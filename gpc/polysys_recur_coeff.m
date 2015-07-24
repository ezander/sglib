function r = polysys_recur_coeff(sys, deg, varargin)

% POLYSYS_RECUR_COEFF Compute recurrence coefficient of orthogonal polynomials.
%   R = POLYSYS_RECUR_COEFF(SYS, DEG) computes the recurrence coefficients for
%   the system of orthogonal polynomials SYS. The signs are compatible with
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

[~, ~, poly]=gpc_register_polysys(sys);
r =poly.recur_coeff(deg);


% switch class(poly)
%     case  'HermitePolynomials'
%         r = [zero, one, n];
%     case 'LEGENDRE'
%         r = [zero, (2*n+1)./(n+1), n ./ (n+1)];
%     case 'CHEBYSHEVT'
%         r = [zero, 2*one - (n==0), one];
%     case  'CHEBYSHEVU'
%         r = [zero, 2*one, one];
%     case 'LAGUERRE'
%         r = [(2*n + 1) ./ (n+1),  -1 ./ (n+1), n ./ (n+1)];
%     case 'MONOMIALS'
%         r = [zero, one, zero];
%     case 'JACOBI'
%         if iscell(dist)
%             a=dist{2}{1}-1;
%             b=dist{2}{2}-1;
%         elseif isa(dist, 'BetaDistribution')
%             a=dist.a-1;
%             b=dist.b-1;
%         elseif isa(dist, 'TranslatedDistribution')
%             a=dist.dist.a-1;
%             b=dist.dist.b-1;
%         end
%         b_n=(2*n+a+b+1).*(2*n+a+b+2)./...
%             ( 2*(n+1).*(n+a+b+1) );
%         a_n=(a^2-b^2).*(2*n+a+b+1)./...
%             ( 2*(n+1).*(n+a+b+1).*(2*n+a+b) );
%         c_n=(n+a).*(n+b).*(2*n+a+b+2)./...
%             ( (n+1).*(n+a+b+1).*(2*n+a+b) );
%         if a+b==0 ||a+b==-1
%             b_n(1)=0.5*(a+b)+1;
%             a_n(1)=0.5*(a-b);
%             c_n(1)=0;
%         end
%         r = [a_n, b_n, c_n];
%     otherwise
%         error('sglib:gpc:polysys', 'Unknown polynomials system: %s', sys);
% end
%  
% 
% if sys == lower(sys) % lower case signifies normalised polynomials
%     z = [0, sqrt(polysys_sqnorm(upper(sys), 0:deg))]';
%     % row n: p_n+1  = (a_n + x b_n) p_n + c_n p_n-1
%     %   =>   z_n+1 q_n+1  = (a_n + x b_n) z_n q_n + c_n z_n-1 p_n-1
%     %   =>   q_n+1  = (a_n + x b_n) z_n/z_n+1 q_n + c_n z_n-1/z_n+1 p_n-1
%     r = [r(:,1) .* z(n+2) ./ z(n+3), ...
%          r(:,2) .* z(n+2) ./ z(n+3), ...
%          r(:,3) .* z(n+1) ./ z(n+3)];
% end
