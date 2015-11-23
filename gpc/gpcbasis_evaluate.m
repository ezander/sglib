function y_alpha_j = gpcbasis_evaluate(V, xi, varargin)
% GPCBASIS_EVALUATE Evaluates the GPC basis functions at given points.
%   Y_ALPHA_J = GPCBASIS_EVALUATE(V, XI) evaluates the GPC basis functions specified
%   by V at the points specified by XI. If there are M basis functions
%   defined on m random variables then XI should be m x N matrix, where N
%   is the number of evaulation points. The returned matrix Y is of size 
%   M x N such that Y(I,j) is the I-th basis function evaluated at point
%   XI(J).
%
%   Y_J_ALPHA = GPCBASIS_EVALUATE(V, XI, 'dual', true) evaluates the dual GPC
%   basis. (Some more explanation needed...)
%   
% Example (<a href="matlab:run_example gpcbasis_evaluate">run</a>)
%
% See also GPC_EVALUATE, GPCBASIS_CREATE

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

options=varargin2options(varargin);
[dual, options]=get_option(options, 'dual', false);
check_unsupported_options(options, mfilename);

% check whether arguments xi and I_a match
syschars = V{1};
I = V{2};
M = size(I, 1);
m = size(I, 2);
k = size(xi, 2);
deg = max(max(I));

check_boolean(length(syschars)==1 || length(syschars)==m, 'length of polynomial system must be one or match the size of the multiindices', mfilename);
check_match(I, xi, false, 'I', 'xi', mfilename);

% p has dimension
%   m x k x deg
% p(j, i, d) contains the value p^(j)_d(xi_(j,d))
% It is evaluated by the recurrence relation
%   p_{n + 1}(x) = (a_n + x b_n) p_n(x) - c_n p_{n - 1}(x)
% here: a_n = r(n,1), b_n = r(n,2), c_n = r(n,3)
p = zeros(m, k, deg);
p(:,:,1) = zeros(size(xi));
p(:,:,2) = ones(size(xi));
if length(syschars)==1
    r = polysys_recur_coeff(syschars, deg);
    for d=1:deg
        p(:,:,d+2) = (r(d,1) + xi * r(d, 2)) .* p(:,:,d+1) - r(d,3) * p(:,:,d);
    end
else
    for j=1:m
        % TODO: not very efficient for mixed gpc
        r = polysys_recur_coeff(syschars(j), deg);
        for d=1:deg
            p(j,:,d+2) = (r(d,1) + xi(j,:) * r(d, 2)) .* p(j,:,d+1) - r(d,3) * p(j,:,d);
        end
    end
end

% y_alpha_j has dimension
%   y_alpha_j: M x k <- (p, I)=(m x k x deg, M x m)
% y_alpha_j(i, i) contains P_I(i)(xi_j)
y_alpha_j = ones(M, k);
for j=1:m
    y_alpha_j = y_alpha_j .* reshape(p(j, :, I(:,j)+2), k, M)';
end

% if dual basis is to be computed
if dual
    nrm2 = gpcbasis_norm(V, 'sqrt', false);
    y_alpha_j = binfun(@rdivide, y_alpha_j, nrm2)';
end
