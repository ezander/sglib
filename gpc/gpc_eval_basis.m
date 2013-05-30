function y = gpc_eval_basis(V, xi, varargin)
% GPC_EVAL_BASIS Evaluates the GPC basis functions at given points.
%   Y = GPC_EVAL_BASIS(V, XI) evaluates the GPC basis functions specified
%   by V at the points specified by XI. If there are M basis functions
%   defined on m random variables then XI should be m x N matrix, where N
%   is the number of evaulation points. The returned matrix Y is of size 
%   M x N such that Y(I,j) is the I-th basis function evaluated at point
%   XI(J).
%
% Example (<a href="matlab:run_example gpc_eval_basis">run</a>)
%
% See also

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

M = size(V{2}, 1);
a_i_alpha = sparse(1:M, 1:M, ones(M,1));
y = gpc_evaluate(a_i_alpha, V, xi);
