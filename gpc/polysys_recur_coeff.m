function r = polysys_recur_coeff(sys, deg)
% POLYSYS_RECUR_COEFF Compute recurrence coefficient of orthogonal polynomials.
%   R = POLYSYS_RECUR_COEFF(SYS, DEG) computes the recurrence coefficients for
%   the system of orthogonal polynomials SYS 
%
%   Note: Normally you don't want to call this function directly. Call one
%   of the GPC functions instead.
%
% Example (<a href="matlab:run_example polysys_recur_coeff">run</a>)
%
% See also GPC

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

n = (0:deg-1)';
one = ones(size(n));
zero = zeros(size(n));
switch upper(sys)
    case 'H'
        r = [zero, one, n];
    case 'P'
        r = [zero, (2*n+1)./(n+1), n ./ (n+1)];
    case 'T'
        r = [zero, 2*one, one];
        r(1,2) = 1;
    case 'U'
        r = [zero, 2*one, one];
    case 'L'
        r = [(2*n + 1) ./ (n+1),  -1 ./ (n+1), n ./ (n+1)];
    otherwise
        error('sglib:gpc:polysys', 'Unknown polynomials system: %s', sys);
end

if sys == lower(sys) % lower case signifies normalised polynomials
    z = [0, sqrt(polysys_sqnorm(upper(sys), 0:deg))]';
    % row n: p_n  = (a_n- + x b_n-) p_n-1 + c_n p_n-2
    %   =>   z_n q_n  = (a_n- + x b_n-) z_n-1 q_n-1 + c_n z_n-2 p_n-2
    %   =>   q_n  = (a_n- + x b_n-) z_n-1/z_n q_n-1 + c_n z_n-2/z_n p_n-2
    r = [r(:,1) .* z(n+2) ./ z(n+3), ...
         r(:,2) .* z(n+2) ./ z(n+3), ...
         r(:,3) .* z(n+1) ./ z(n+3)];
end
