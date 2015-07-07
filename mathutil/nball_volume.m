function V=nball_volume(n, r)
% NBALL_VOLUME Returns the volume of a ball in R^n.
%   V=NBALL_VOLUME(N, R) returns the volume of an N-dimensional ball of
%   radius R. 
%   V=NBALL_VOLUME(N) returns the volume of the N-dimensional unit ball.
%
%   The dimensions of N and R can be matrix valued such that both can be
%   broadcast to match each other, i.e. the dimensions either match or
%   exactly or the other array has a singleton dimension in the
%   corresponding direction (see help for BINFUN).
%
% References
%   [1] https://en.wikipedia.org/wiki/Ball_(mathematics) 
%   [2] https://en.wikipedia.org/wiki/Volume_of_an_n-ball
%
% Example (<a href="matlab:run_example nball_volume">run</a>)
%   strvarexpand( 'The area of a circle of radius 10 is $nball_volume(2, 10)$');
%   strvarexpand( 'The volume of a ball of radius 10 is $nball_volume(3, 10)$');
%   strvarexpand( 'The "volume" of a 4-ball of radius 10 is $nball_volume(4, 10)$');
%
% See also NBALL_SURFACE

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

% Volume of n-dim unit ball
V1 = pi.^(n/2) ./ gamma(n/2+1);
% Volume of n cube of edge length r
Cn = binfun(@power, r, n);
% Volume of the n-ball is the product of the latter two
V =  binfun(@times, V1, Cn);
