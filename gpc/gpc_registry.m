function varargout = gpc_registry(action, varargin)
% GPC_REGISTRY Short description of gpc_registry.
%   [POLYSYS, DIST] = GPC_REGISTRY(ACTION, SYSCHAR, POLYSYS, DIST) Long description of gpc_registry.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example gpc_registry">run</a>)
%
% See also

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

persistent gpcreg

if isempty(gpcreg)
    gpcreg = GPCRegistry();
end

if ismethod(gpcreg, action)
    [varargout{1:nargout}]=gpcreg.(action)(varargin{:});
elseif strcmp(action, 'object')
    varargout = {gpcreg};
else
    error('sglib:gpc_registry:unknown_action', 'Unknown action: %s', action);
end
