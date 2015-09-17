function varargout=gpcbasis_info(V, type, varargin)
% GPCBASIS_INFO Short description of gpcbasis_info.
%   GPCBASIS_INFO Long description of gpcbasis_info.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example gpcbasis_info">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

germ = V{1};
I = V{2};

switch type
    case {'M', 'size', 'num_basis_functions'}
        varargout{1} = size(I, 1);
    case {'m', 'germ_size'}
        varargout{1} = size(I, 2);
    case {'max_degrees'}
        varargout{1} = max(I, 1);
    case {'max_degree'}
        varargout{1} = max(I(:));
    case {'order'}
        varargout{1} = multiindex_order(I);
    case {'total_degree'}
        varargout{1} = max(multiindex_order(I));
    otherwise
        error('sglib:gpc', 'Unknown info type "%s" for gpcbasis_info', type );
end
