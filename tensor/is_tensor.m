function [bool,format]=is_tensor(T)
% IS_CTENSOR Checks whether object is in a recognized tensor format.
%   BOOL=IS_CTENSOR(T) returns true if T is in a recognized tensor format.
%   Currently that means that T may be a full tensor or in canonical
%   format. (Tucker format will follow).
%
% Example (<a href="matlab:run_example is_ctensor">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

bool=false;
format='';

if isnumeric(T)
    bool=true;
    format='full';
    return;
elseif is_ctensor(T)
    bool=true;
    format='canonical';
    return;
elseif isobject(T)
    bool=true;
    format=['class:' class(T)];
end
