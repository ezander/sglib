function v=multivector_init(n, m)
% MULTIVECTOR_INIT Initialise a multivector.
%   V=MULTIVECTOR_INIT(N, M) Initalises a multivector of size "N" x M,
%   where M is an integer and N can be either an integer, a cell array
%   containing integers or a struct containing integers. The result is
%   correspondingly either a double array of size N x M, a cell array with
%   entries being double arrays of size N{I} x M, or a struct where field
%   FIELDNAME would contain a double array of size N.FIELDNAME x M.
%
% Example (<a href="matlab:run_example multivector_init">run</a>)
%   multivector_init(2, 3)
%   multivector_init({2,4,5}, 3)
%   multivector_init(struct('foo', 6, 'bar', 8), 3)
% 
% See also MULTIVECTOR_UPDATE

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

if iscell(n)
    v = cell(size(n));
    for i=1:numel(n)
        v{i} = multivector_init(n{i}, m);
    end
elseif isstruct(n)
    assert(isscalar(n), 'Struct arrays don''t work');
    names = fieldnames(n);
    v = struct();
    for i=1:numel(names)
        v.(names{i}) = multivector_init(n.(names{i}), m);
    end
else
    v = zeros(n, m);
end
