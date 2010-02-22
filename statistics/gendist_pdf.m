function y=gendist_pdf(x, dist, params, shift, scale)
% GENDIST_PDF Short description of gendist_pdf.
%   GENDIST_PDF Long description of gendist_pdf.
%
% Example (<a href="matlab:run_example gendist_pdf">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
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
x=(x-shift-mean)/scale+mean;
y=feval( [dist '_pdf'], x, params{:} )/scale;
