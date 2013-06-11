function appdata=sglib_get_appdata( item, default )
% SGLIB_GET_APPDATA Retrieves SGLib application specific data.
%   SGLIB_GET_APPDATA retrieves a data structure in which SGLib methods
%   store data about user settings, statistics, runtime information and the
%   like.
%
% Example (<a href="matlab:run_example sglib_get_appdata">run</a>)
%   sglib_get_appdata( 'basepath' )
%   sglib_get_appdata
%
% See also SGLIB_SET_APPDATA

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

appdata=getappdata( 0, 'sglib' );
if nargin>=1 && ~isempty(item)
    if isfield(appdata,item)
        appdata=appdata.(item);
    elseif nargin>=2
        appdata=default;
    else
        appdata=struct();
    end
end
