function m=lognormal_raw_moments(n, mu, sigma)
% LOGNORMAL_RAW_MOMENTS Compute raw moments of the lognormal distribution.
%
% Example (<a href="matlab:run_example lognormal_raw_moments">run</a>)
%   m=lognormal_raw_moments( 0:5, 1.3, 0.2 )
%
% See also LOGNORMAL_MOMENTS

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<2
    mu=0;
end
if nargin<3
    sigma=1;
end

m=exp( n*mu + n.^2*sigma^2 /2 );
