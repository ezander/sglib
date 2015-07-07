function S=nball_surface(n, r)
% NBALL_SURFACE Returns the surface area of a ball in R^n.
%   S=NBALL_SURFACE(N, R) returns the surface of an N-dimensional ball of
%   radius R. 
%   S=NBALL_SURFACE(N) returns the surface of the N-dimensional unit ball.
%
%   The dimensions of N and R can be matrix valued such that both can be
%   broadcast to match each other, i.e. the dimensions either match or
%   exactly or the other array has a singleton dimension in the
%   corresponding direction (see help for BINFUN).
%
% Note:
%   The surface of a ball in R^N is a N-1 dimensional manifold, and thus in
%   topology called an N-1 sphere. It was deemed more practical here, to
%   use N-balls, where N specifies the dimension of the surrounding space.
%
% References
%   [1] https://en.wikipedia.org/wiki/Ball_(mathematics) 
%   [2] https://en.wikipedia.org/wiki/Volume_of_an_n-ball
%
% Example (<a href="matlab:run_example nball_surface">run</a>)
%   strvarexpand( 'The circumference of a circle of radius 5 is $nball_surface(2, 5)$');
%   strvarexpand( 'The surface of a ball of radius 5 is $nball_surface(3, 5)$');
%   strvarexpand( 'The "surface" of a 4-ball of radius 5 is $nball_surface(4, 5)$');
%   
% See also NBALL_VOLUME, BINFUN

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

% Surface of n-dim unit ball
S1 = 2 * pi.^(n/2) ./ gamma(n/2); 
% Volume of n-1 cube of edge length r
An = binfun(@power, r, n-1);
% Surface of the n-ball is the product of the latter two
S =  binfun(@times, S1, An);
