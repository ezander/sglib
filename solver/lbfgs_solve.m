function q = lbfgs_solve(H0, Y, S, q)
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

inner_sq = nan(1, k);
inner_yr = nan(1, k);
inner_ys = nan(1, k);
for i=k:-1:1
    inner_ys(i) = tensor_scalar_product(Y{i}, S{i});
    inner_sq(i) = tensor_scalar_product(S{i}, q);
    q = tensor_add(q, Y{i}, -inner_sq(i)/inner_ys(i));
end

if isempty(H0)
    if k>0
        tau = tensor_scalar_product(Y{k}, S{k}) / ...
            tensor_scalar_product(Y{k}, Y{k});
        q = tensor_scale(q, tau);
    end
else
    q = operator_apply(H0, q);
end

for i=1:k
    inner_yr(i) = tensor_scalar_product(Y{i}, q);
    q = tensor_add(q, S{i}, (inner_sq(i)-inner_yr(i))/inner_ys(i));
end
