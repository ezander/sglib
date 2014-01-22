function y=gendist_pdf(x, dist, varargin)
% GENDIST_PDF Short description of gendist_pdf.
%   GENDIST_PDF Long description of gendist_pdf.
%
% Example (<a href="matlab:run_example gendist_pdf">run</a>)
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

x=(x-shift-mean)/scale+mean;
y=feval( [distname '_pdf'], x, params{:} )/scale;
