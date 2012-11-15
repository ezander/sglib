function a_i=gpc_evaluate( a_i_alpha, V_a, xi )
% GPC_EVALUATE Evaluate a GPC at a given number of sample points.
%   A_I=GPC_EVALUATE( A_I_ALPHA, V_A, XI ) computes a realization of
%   the GPC expansion given by the coefficients in A_I_ALPHA w.r.t.
%   multiindex I_A at the sample point(s) given by XI.
% 
% Dimensions:
%   a_i_alpha : N x M
%   I_a       : M x m
%   xi        : m x k
%   a_i       : N x k
%   where N is the spatial dimension, M the stochastic dimension, m the
%   number of basic random variables, and k the number of evaluation
%   points.
%
% Example (<a href="matlab:run_example gpc_evaluate">run</a>)
%   I_a=multiindex( 2, 3 );           % m=2, M=10
%   V_a={'hp', I_a};
%   a_i_alpha=cumsum(ones( 5, 10 ));  % N=5
%   xi=gpc_sample(V_a, 7);            % k=7
%   gpc_evaluate( a_i_alpha, V_a, xi )
%
% See also GPC, GPC_SAMPLE

%   Elmar Zander
%   Copyright 2012, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% check whether arguments xi and I_a match
sys = V_a{1};
I_a = V_a{2};
N = size(a_i_alpha, 1); %#ok<NASGU>
M = size(I_a, 1);
m = size(I_a, 2);
k = size(xi, 2);
deg = max(max(I_a));

assert(length(sys)==1 || length(sys)==m)
check_match(a_i_alpha, I_a, false, 'a_i_alpha', 'I_a', mfilename);
check_match(I_a, xi, false, 'I_a', 'xi', mfilename);

% p has dimension
%   m x k x deg
% p(j, i, d) contains the value p^(j)_d(xi_(j,d))
% It is evaluated by the recurrence relation
%   p_{n + 1}(x) = (a_n + x b_n) p_n(x) - c_n p_{n - 1}(x)
% here: a_n = r(n,1), b_n = r(n,2), c_n = r(n,3)
p = zeros(m, k, deg);
p(:,:,1) = zeros(size(xi));
p(:,:,2) = ones(size(xi));
if length(sys)==1
    r = poly_recur_coeff(sys, deg);
    for d=1:deg
        p(:,:,d+2) = (r(d,1) + xi * r(d, 2)) .* p(:,:,d+1) - r(d,3) * p(:,:,d);
    end
else
    for j=1:m
        % TODO: not very efficient for mixed gpc
        r = poly_recur_coeff(sys(j), deg);
        for d=1:deg
            p(j,:,d+2) = (r(d,1) + xi(j,:) * r(d, 2)) .* p(j,:,d+1) - r(d,3) * p(j,:,d);
        end
    end
end

% q has dimension
%   q: M x k <- (p, I)=(m x k x deg, M x m)
% q(j, i) contains P_I(j)(xi_i)
q = ones(M, k);
for j=1:m
    q = q .* reshape(p(j, :, I_a(:,j)+2), k, M)';
end

% N x M : (N x M) * (M x k)
a_i = a_i_alpha * q;

    
function r = poly_recur_coeff(sys, deg)
n = (0:deg-1)';
switch upper(sys)
    case 'H'
        r = [zeros(size(n)), ones(size(n)), n];
    case 'P'
        r = [zeros(size(n)), (2*n+1)./(n+1), n ./ (n+1)];
    otherwise
        error('sglib:gpc:polysys', 'Unknown polynomials system: %s', sys);
end
if sys == lower(sys) % lower case signifies normalised polynomials
    z = [0; gpc_norm( {upper(sys), (0:deg)'})];
    % row n: p_n  = (a_n- + x b_n-) p_n-1 + c_n p_n-2
    % row n: z_n q_n  = (a_n- + x b_n-) z_n-1 q_n-1 + c_n z_n-2 p_n-2
    % row n: q_n  = (a_n- + x b_n-) z_n-1/z_n q_n-1 + c_n z_n-2/z_n p_n-2
    r = [r(:,1) .* z(n+2) ./ z(n+3), ...
         r(:,2) .* z(n+2) ./ z(n+3), ...
         r(:,3) .* z(n+1) ./ z(n+3)];
end
