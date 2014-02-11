function A=tensor_operator_create(ops, varargin)
% TENSOR_OPERATOR_CREATE Create a tensor operator.
%   TENSOR_OPERATOR_CREATE Long description of tensor_operator_create.
%
% Example (<a href="matlab:run_example tensor_operator_create">run</a>)
%   for i=1:5; K{i}=rand(10); end
%   for i=1:5; X{i}=rand(20); end
%   A = tensor_operator_create({K,X});
%
% See also TENSOR_OPERATOR_ORDER, TENSOR_OPERATOR_APPLY

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

D = length(ops);
R = length(ops{1});

A = cell(R, D);
for d=1:D
    A(:,d) = ops{d};
end
