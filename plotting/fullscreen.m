function fullscreen(handle)
% FULLSCREEN Set figure to fullscreen.
%   FULLSCREEN(HANDLE) Long description of fullscreen.
%
% Example (<a href="matlab:run_example fullscreen">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2018, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<1
    handle = gcf;
end

undock(handle)
set(handle, 'units','normalized','outerposition',[0 0 1 1])
