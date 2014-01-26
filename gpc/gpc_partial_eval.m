function [b_i_alpha, V_b] = gpc_partial_eval(a_i_alpha, V_a, k, xi)
% GPC_PARTIAL_EVAL Partially evaluates a GPC and returns the reduced GPC.
%   [B_I_ALPHA, V_B] = GPC_PARTIAL_EVAL(A_I_ALPHA, V_A, K, XI) sets the
%   K-th basic random variable in the GPC described by A_I_ALPHA and V_A to
%   XI and returns a GPC with this random variable removed. This means, if
%   XI1 and XI2 are samples of size K-1 and M-K, then it holds that:
%   GPC_EVALUATE(A_I_ALPHA, V_A, [XI1, XI, XI2])==GPC_EVALUATE(B_I_ALPHA,
%   V_B, [XI1, XI2]). 
%
%   K and XI can also be vectors of the same size.
%
% Example (<a href="matlab:run_example gpc_partial_eval">run</a>)
%   I_a = multiindex(4,2);
%   V_a = {'uHpl', I_a};
%   a_i_alpha = randn(4, size(I_a, 1));
%   xi_a = gpcgerm_sample(V_a);
%   k = 3;
%   [b_i_alpha, V_b] = gpc_partial_eval(a_i_alpha, V_a, k, xi_a(k));
%   xi_b = xi_a;
%   xi_b(k) = [];
%   % print out the old multiindex set
%   underline(sprintf('\n%c, %c, %c, %c', V_a{1}));
%   fprintf('%d, %d, %d, %d\n', V_a{2});
%   % print out the new multiindex set (p is gone now)
%   underline(sprintf('\n%c, %c, %c', V_b{1}));
%   fprintf('%d, %d, %d\n', V_b{2});
%   % evaluation gives the same results
%   [gpc_evaluate(b_i_alpha, V_b, xi_b), gpc_evaluate(a_i_alpha, V_a, xi_a)]
%
% See also GPC_EVALUATE, GPCGERM_SAMPLE, MULTIINDEX

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if length(k)==1
    [b_i_alpha, V_b] = gpc_partial_eval_onevar(a_i_alpha, V_a, k, xi);
else
    for j=1:length(k)
        [a_i_alpha, V_a] = gpc_partial_eval_onevar(a_i_alpha, V_a, k(j), xi(j));
        ind = (k>k(j));
        k(ind) = k(ind) - 1;
    end
    b_i_alpha = a_i_alpha;
    V_b = V_a;
end
    
function [b_i_alpha, V_b] = gpc_partial_eval_onevar(a_i_alpha, V_a, k, xi)
% GPC_PARTIAL_EVAL_ONEVAR Does the partial evaluation for only one variable

% dissect the gpc space, and determine the polynomial systems
[polys_a, I_a] = deal(V_a{:});
if length(polys_a)==1
    polys_k = polys_a;
    polys_b = polys_a;
else
    polys_k = polys_a(k);
    polys_b = polys_a([1:k-1, k+1:end]);
end

% evaluate polynomials at column k of multiindex I_a
M = size(I_a, 1);
I_k = I_a(:,k);
p_k = max(I_k);
V_k = {polys_k, (0:p_k)'};
v_k = gpc_evaluate(sparse(1:M, I_k+1, ones(M,1)), V_k, xi);

% remove column from multiindex set I_a and create new unique set I_b
I_a(:,k) = [];
[I_b, dummy, ind] = unique(I_a, 'rows'); %#ok<ASGLU>

% create projection matrix P and compute new GPC coefficients
P = sparse(1:length(ind), ind, v_k);

b_i_alpha = a_i_alpha * P;
V_b = {polys_b, I_b};
