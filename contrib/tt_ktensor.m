function varargout=tt_ktensor(varargin)
% TT_KTENSOR Short description of tt_ktensor.
%   TT_KTENSOR Long description of tt_ktensor.
%
% Example (<a href="matlab:run_example tt_ktensor">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

tt_available(true);
varargout{:}=ktensor(varargin{:});
