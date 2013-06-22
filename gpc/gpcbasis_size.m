function [m1, m2] = gpcbasis_size(V, dim)
% GPCBASIS_SIZE Short description of gpcbasis_size.
%   GPCBASIS_SIZE Long description of gpcbasis_size.
%
% Example (<a href="matlab:run_example gpcbasis_size">run</a>)
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

if nargin<2
    dim = 1;
else
    if nargout==2
        error('sglib:gpc_size', 'can''t specify dimension with multiple output argument');
    end
    dim = -1;
end

switch dim
    case 1
        m1 = size(V{2}, 1);
    case 2
        m2 = size(V{2}, 2);
    case -1
        [m1, m2] = size(V{2});
    otherwise
        error('sglib:gpc_size', 'invalide value for input paramter ''dim'' specified: %s', strvarexpand());
end   
        