function x = lbfgs_solve(H0, Y, S, b)
% LBFGS_SOLVE Solve with the L-BFGS Hessian approximation.
%   X = LBFGS_SOLVE(H0, Y, S, B) returns the solution of H*X=B, where H is
%   the Hessian approximation given by H0 and the BFGS update vectors in Y
%   and S. H0 can be an object of a subclass of Operator or a matrix. Y and
%   S need to be cell arrays containing the BFGS update vectors. 
%
% References
%   [1] Nocedal, J. and Wright, S.J. (1999): Numerical Optimization,
%       Springer-Verlag. ISBN 0-387-98793-2.
%   [2] http://en.wikipedia.org/wiki/Limited-memory_BFGS
%
% See also QN_MATRIX_UPDATE, LBFGSOPERATOR

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

k = length(S);
assert(k==length(Y), 'Y and S must have same length');

alpha = nan(1, k);
beta = nan(1, k);
rho = nan(1, k);
for i=k:-1:1
    rho(i) = 1 / tensor_scalar_product(Y{i}, S{i});
    alpha(i) = rho(i) * tensor_scalar_product(S{i}, b);
    b = tensor_add(b, Y{i}, -alpha(i));
end

if isempty(H0)
    x = b;
    if k>0
        tau = tensor_scalar_product(Y{k}, S{k}) / tensor_scalar_product(Y{k}, Y{k});
        x = tensor_scale(x, tau);
    end
else
    x = operator_apply(H0, b);
end

for i=1:k
    beta(i) = rho(i) * tensor_scalar_product(Y{i}, x);
    x = tensor_add(x, S{i}, alpha(i)-beta(i));
end
