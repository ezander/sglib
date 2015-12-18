function varargout=multivector_map(func, u)
% MULTIVECTOR_MAP Apply some function to all field of a multivector.
%   [V1, V2, ...]=MULTIVECTOR_MAP(FUNC, U) applies FUNC to all fields of
%   the multivector U. If FUNC has more than one output, the outputs can be
%   captured in V1, V2, ..., where each of the VI is a multivector with the
%   same structure as U.
%
% Example (<a href="matlab:run_example multivector_map">run</a>)
%     u = {rand(3, 5), rand(7,5)};
%     [u_mean, u_var] = multivector_map(@data_moments, u)
%
%     u = struct();
%     u.a = rand(3, 5); u.b = rand(7,5);
%     [u_mean, u_var] = multivector_map(@data_moments, u)
%
% See also MULTIVECTOR_INIT, MULTIVECTOR_UPDATE

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

nout = nargout;
v = cell(1, nout);
argout = cell(1, nout);

if iscell(u)
    for j=1:nout
        v{j} = cell(size(u));
    end
    for i=1:numel(u)
        [argout{:}] = multivector_map(func, u{i});
        for j=1:nout
            v{j}{i} = argout{j};
        end
    end
elseif isstruct(u)
    names = fieldnames(u);
    for j=1:nout
        v{j} = struct();
    end
    for i=1:numel(names)
        [argout{:}] = multivector_map(func, u.(names{i}));
        for j=1:nout
            v{j}.(names{i}) = argout{j};
        end
    end
else
    [argout{:}] = funcall(func, u);
    v = argout;
end

varargout = v;
