function old_state=dock( handle, state )
% DOCK Docks a figure window into the workspace.
%   DOCK() puts the current figure window into docked state and places it
%   into the workspace window.
%
%   OLD_STATE=DOCK( HANDLE, STATE ) sets the state of the figure window
%   with handle HANDLE to STATE and returns the previous state. All input
%   and output arguments are optional.
%
%   Use a combination of DOCK/UNDOCK on the command line, and
%   OLD=DOCK(H)/DOCK(H,OLD) programmatically.
%
% Example (<a href="matlab:run_example dock">run</a>)
%   % calling the power function
%   figure;
%   x=linspace(0,2*pi);
%   plot( x, sin(x) );
%   dock();
%
% See also UNDOCK, GCF, SET, GET

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


if ~exist( 'handle', 'var' ) || isempty(handle)
    handle=gcf;
end
if ~exist( 'state', 'var' ) || isempty(state)
    state='docked';
end

if nargout>0
    old_state=get( handle, 'WindowStyle' );
end

set( handle, 'WindowStyle', state );
