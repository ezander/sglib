function medit_replace_edit(bool)
% MEDIT_REPLACE_EDIT Replaces the matlab edit function by medit.
%   MEDIT_REPLACE_EDIT replaces the matlab EDIT function by the sglib MEDIT
%   function. This is achieved by just prepending the corresponding path
%   with an EDIT replacement. 
%
%   MEDIT_REPLACE_EDIT(FALSE) removed the replacement of the matlab EDIT
%   function by the sglib MEDIT function again. A call to EDIT now calls
%   directly the matlab EDIT function.
%
% Notes
%   The reason for the existence of this function is that tab completion
%   does not work with MEDIT can you can't make matlab do it because it's
%   hardcoded for only some functions like EDIT or LS deep inside. Since I
%   don't want to replace EDIT directly for everybody I made it optional by
%   invoking this function.
%
% Example (<a href="matlab:run_example medit_replace_edit">run</a>)
%   medit_replace_edit
%   edit foobar
%
% See also

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<1
    bool = true;
end

basepath = sglib_get_appdata( 'basepath' );
editreppath = fullfile( basepath, 'util/editrep');

if bool
    addpath( editreppath );
else
    rmpath( editreppath );
end
