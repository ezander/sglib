function mp_data = multiplot_data(getset, new_mp_data)
% MULTIPLOT_DATA Internal function to get/set multiplot data.
%   MULTIPLOT_DATA('get') returns the current multiplot administrative data
%   structure.
%
%   MULTIPLOT_DATA('set', NEW_MP_DATA) sets the current multiplot
%   administrative data structure.
%
% Example (<a href="matlab:run_example multiplot_data">run</a>)
%   % Do not use this function explicitly
%
% See also MULTIPLOT_INIT, MULTIPLOT

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

persistent pers_mp_data;

if nargin<1
    getset='get';
end

switch(getset)
    case 'get'
        if( isempty(pers_mp_data) )
            pers_mp_data = struct();
        end
        mp_data = pers_mp_data;
    case 'set'
        pers_mp_data = new_mp_data;
    otherwise
        error('sglib:multiplot_data', 'Unknown GETSET string: "%s"', getset);
end
