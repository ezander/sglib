function x=gendist_invcdf(y, dist, params, shift, scale)
% GENDIST_INVCDF Short description of gendist_invcdf.
%   GENDIST_INVCDF Long description of gendist_invcdf.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example gendist_invcdf">run</a>)
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

if ~exist('shift', 'var' ) || isempty(shift)
    shift=0;
end
if ~exist('scale', 'var' ) || isempty(scale)
    scale=1;
end
if ~exist('params', 'var' ) 
    params={};
end

mean=gendist_moments( dist, params );
x=feval( [dist '_invcdf'], y, params{:} );
x=(x-mean)*scale+mean+shift;
