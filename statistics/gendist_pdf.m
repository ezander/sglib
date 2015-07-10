function y=gendist_pdf(x, dist, varargin)
% GENDIST_PDF Probability distribution function for a gendist.
%   Y=GENDIST_PDF(X, DIST) computes the pdf for the probablity distribution
%   DIST for all values in X
%
% Example (<a href="matlab:run_example gendist_pdf">run</a>)
%   dist = gendist_create('normal', {2, 0.3});
%   x = linspace(0, 5);
%   plot(x, gendist_pdf(x, dist));
%
% See also GENDIST_CREATE, GENDIST_CDF, GENDIST_MOMENTS

%   Elmar Zander
%   Copyright 2009, 2014, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isa(dist, 'Distribution')
    y = dist.pdf(x);
    return
end

[distname, params, shift, scale, mean] = gendist_get_args(dist, varargin);

x=(x-shift-mean)/scale+mean;
y=feval( [distname '_pdf'], x, params{:} )/scale;
