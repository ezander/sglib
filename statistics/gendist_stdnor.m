function y=gendist_stdnor(x, dist, varargin)
% GENDIST_STDNOR Short description of gendist_stdnor.
%   GENDIST_STDNOR Long description of gendist_stdnor.
%
% Example (<a href="matlab:run_example gendist_stdnor">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

[distname, params, shift, scale, mean] = gendist_get_args(dist, varargin);

y=feval( [distname '_stdnor'], x, params{:} );
y=(y-mean)*scale+mean+shift;
