function [r, xi] = gpc_sample(r_alpha, V, n, varargin)
% GPC_SAMPLE Short description of gpc_sample.
%   GPC_SAMPLE Long description of gpc_sample.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example gpc_sample">run</a>)
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

xi = gpcgerm_sample(V, n, varargin{:});
r = gpc_evaluate(r_alpha, V, xi);
