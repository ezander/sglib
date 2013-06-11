function undock( handle )
% UNDOCK Undocks a figure window from the workspace.
%   UNDOCK() puts the current figure window into undocked state.
%
%   UNDOCK( HANDLE ) sets the state of the figure window
%   with handle HANDLE into undocked state.
%
% Example (<a href="matlab:run_example undock">run</a>)
%   % calling the power function
%   figure;
%   x=linspace(0,2*pi);
%   plot( x, sin(x) );
%   dock();
%   disp( 'Press enter to undock' );
%   userwait;
%   undock;
%
% See also DOCK

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if ~exist( 'handle', 'var' )
    handle=[];
end
dock( handle, 'normal' );
