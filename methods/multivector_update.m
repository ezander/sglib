function v=multivector_update(v, a, u, b)
% MULTIVECTOR_UPDATE Update a multivector.
%   V=MULTIVECTOR_UPDATE(V, A, U, B) returns a V + A * U * B where V and U
%   are multivectors, i.e. either a normal double array or a cell array or
%   struct of double arrays. It performs the aforementioned operation
%   uniformly over entries. The factor A must be a scalar while B can be a
%   matrix of appropriate size, i.e. if V is a multivector of size N x M_V
%   and U is a multivector of size N x M_U, then B must be of size M_U x
%   M_V.
%
% Example (<a href="matlab:run_example multivector_update">run</a>)
%   
% See also MULTIVECTOR_INIT

%   Elmar Zander
%   Copyright 2015, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if iscell(v)
    for i=1:numel(v)
        v{i} = multivector_update(v{i}, a, u{i}, b);
    end
elseif isstruct(v)
    names = fieldnames(v);
    for i=1:numel(names)
        v.(names{i}) = multivector_update(v.(names{i}), a, u.(names{i}), b);
    end
else
    v = v + a * u * b;
end
