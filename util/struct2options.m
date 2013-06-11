function opts=struct2options(s)
% STRUCT2OPTIONS Short description of struct2options.
%   STRUCT2OPTIONS Long description of struct2options.
%
% Example (<a href="matlab:run_example struct2options">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if ~isstruct(s)
    error( 'sglib:struct2options:param_error', 'Argument to struct2options must be a struct' );
end

names=fieldnames(s);
vals=struct2cell(s);
opts=reshape( [names(:), vals(:)]', 1, [] );
