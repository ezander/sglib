function y=gendist_stdnor(x, dist, params, shift, scale)
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

if ~exist('shift', 'var' ) || isempty(shift)
    shift=0;
end
if ~exist('scale', 'var' ) || isempty(scale)
    scale=1;
end
if ~exist('params', 'var' ) 
    params={};
end

y=feval( [dist '_stdnor'], x, params{:} );
mean=gendist_moments( dist, params );
y=(y-mean)*scale+mean+shift;
