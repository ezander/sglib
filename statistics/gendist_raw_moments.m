function m=gendist_raw_moments(n, dist, varargin)
% GENDIST_RAW_MOMENTS Short description of gendist_raw_moments.
%   GENDIST_RAW_MOMENTS(VARARGIN) Long description of gendist_raw_moments.
%
% Example (<a href="matlab:run_example gendist_raw_moments">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isa(dist, 'Distribution')
    m = dist.raw_moments(n);
    return
end

[distname, params, shift, scale] = gendist_get_args(dist, varargin);
assert(shift==0, 'shift parameter not supported yet for gendist_raw_moments');
assert(scale==1, 'scale parameter not supported yet for gendist_raw_moments');

m=feval( [distname '_raw_moments'], n, params{:} );

