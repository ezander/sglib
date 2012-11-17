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
%   ai=gpc_evaluate( a_i_alpha, V_a, xi );
%   
%   subplot(3,2,1)
%   xi = linspace(-3,3);
%   plot(xi, gpc_evaluate( eye(6), {'H', (0:5)'}, xi));
%   title('Hermite (stoch.)'); ylim([-10, 10]); grid on;
%   subplot(3,2,2)
%   xi = linspace(-1,1);
%   plot(xi, gpc_evaluate( eye(6), {'P', (0:5)'}, xi));
%   title('Legendre'); grid on;
%   subplot(3,2,3)
%   xi = linspace(-1,1);
%   plot(xi, gpc_evaluate( eye(6), {'T', (0:5)'}, xi));
%   title('Chebyshev 1st'); grid on;
%   subplot(3,2,4)
%   xi = linspace(-1,1);
%   plot(xi, gpc_evaluate( eye(6), {'U', (0:5)'}, xi));
%   title('Chebyshev 2nd'); ylim([-1.5, 1.5]); grid on;
%   subplot(3,2,5)
%   xi = linspace(-5,20);
%   plot(xi, gpc_evaluate( eye(6), {'L', (0:5)'}, xi));
%   title('Laguerre'); ylim([-10, 20]); grid on;
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
    r = polysys_recur_coeff(sys, deg);
    for d=1:deg
        p(:,:,d+2) = (r(d,1) + xi * r(d, 2)) .* p(:,:,d+1) - r(d,3) * p(:,:,d);
    end
else
    for j=1:m
        % TODO: not very efficient for mixed gpc
        r = polysys_recur_coeff(sys(j), deg);
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
