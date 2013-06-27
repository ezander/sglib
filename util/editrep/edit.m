function edit(varargin)
% EDIT Replacement of the builtin edit function.
%   EDIT(FILENAME) edits the file indicated by FILENAME by the sglib MEDIT
%   function (which in turn calls the matlab function EDIT). If you want to
%   call the original again call MEDIT_REPLACE_EDIT with argument FALSE.
%
% See also MEDIT, MEDIT_REPLACE_EDIT

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

medit(varargin{:});
