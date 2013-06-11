function sglib_set_appdata( appdata, item )
% SGLIB_SET_APPDATA Stores SGLib application specific data.
%   SGLIB_SET_APPDATA( APPDATA ) stores the complete SGLib app data
%   structure. If ITEM is specified the data is stored in a structure field
%   with name ITEM in the SGLib appdata.
%
% Example (<a href="matlab:run_example sglib_set_appdata">run</a>)
%   stats=sglib_get_appdata( 'mystats', 0 )
%   stats=stats+1;
%   sglib_set_appdata( stats, 'mystats' );
%   stats=sglib_get_appdata( 'mystats' )
%
% See also SGLIB_GET_APPDATA

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

if nargin>=2 && ~isempty(item)
    data=appdata;
    appdata=sglib_get_appdata();
    appdata.(item)=data;
end
setappdata( 0, 'sglib', appdata );
