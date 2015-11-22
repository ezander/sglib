function [polysys, dist] = gpc_register_polysys_new(action, syschar, polysys, dist)
% GPC_REGISTER_POLYSYS_NEW Short description of gpc_register_polysys_new.
%   GPC_REGISTER_POLYSYS_NEW(VARARGIN) Long description of gpc_register_polysys_new.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example gpc_register_polysys_new">run</a>)
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

persistent registry
persistent char2index

if isempty(registry)
    registry = struct('syschar', {}, 'polysys', {}, 'dist', {});
    registry(end+1) = make_reg_entry('H', HermitePolynomials());
    registry(end+1) = make_reg_entry('h', HermitePolynomials().normalized());
    registry(end+1) = make_reg_entry('P', LegendrePolynomials());
    registry(end+1) = make_reg_entry('p', LegendrePolynomials().normalized());
    
    char2index = zeros(256,1);
    chars = double(char(registry.syschar));
    indices = 1:length(registry);
    char2index(chars) = indices;
end

switch action
    case 'get'
        index = char2index(syschar);
        if index
            entry = registry(index);
            assert(syschar == entry.syschar);
            polysys = entry.polysys;
            dist = entry.dist;
        end
    case 'set'
        index = char2index(syschar);
        if index
            error('already set');
        end
        dist = polysys.weighting_dist();
        entry = make_reg_entry(syschar, polysys, dist)
        registry(end+1) = entry;
        char2index(syschar) = length(registry);
    case 'getall'
        polysys = registry;
    otherwise
        error('foobar');
end





function entry = make_reg_entry(syschar, polysys, dist)
entry.syschar = syschar;
entry.polysys = polysys;
if nargin>2
    entry.dist = dist;
else
    entry.dist = polysys.weighting_dist();
end
