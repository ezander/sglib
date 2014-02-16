function bool=is_ctensor(T)
% IS_CTENSOR Checks whether object is canonical tensor format.
%   BOOL=IS_CTENSOR(T) returns true if T is in a recognized tensor format.
%   Currently that means that T if in canonical format.
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

if ~iscell(T)
    return;
end

if ~isvector(T)
    return;
end

isnum=cellfun(@isnumeric, T );
if ~all(isnum)
    return
end

ndims=cellfun( 'ndims', T );
dim2=cellfun( 'size', T, 2 );

% first check for canonical format
if all(ndims==2) && all(dim2(:)==dim2(1))
    bool=true;
    return;
end

% not canonical, try tucker (i.e. first ones is core tensor);
% note: tucker stuff will go into separate function
%     if ndims(1)==length(T)-1 && all(ndims(2:end)==2)
%         dim1=cellfun( 'size', T, 1 );
%         if all(dim2(2:end)==dim2(2)) && all(dim1(2:end)==ndims(1))
%             bool=true;
%             format='tucker';
%             return;
%         end
%     end

    