function V=nball_volume(n, r)
% NBALL_VOLUME Short description of nball_volume.
%   NBALL_VOLUME(VARARGIN) Long description of nball_volume.
%
% References
%   [1] https://en.wikipedia.org/wiki/Ball_(mathematics) 
%   [2] https://en.wikipedia.org/wiki/Volume_of_an_n-ball
%
% Example (<a href="matlab:run_example nball_volume">run</a>)
%
% See also NBALL_SURFACE, NBALL_RADIUS

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

if nargin<2
    r = 1;
end

V = pi.^(n/2) ./ gamma(n/2+1) .* (r.^n);
