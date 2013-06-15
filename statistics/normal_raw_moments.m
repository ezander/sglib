function m=normal_raw_moments(n, mu, sigma)
% NORMAL_RAW_MOMENTS Compute raw moments of the normal distribution.
%
% Example (<a href="matlab:run_example normal_raw_moments">run</a>)
%   m=normal_raw_moments( 0:10, 0, 1 )
%
% See also NORMAL_MOMENTS

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

max_n=max(n(:));
M=zeros(1,max_n+1);
for j=0:max_n
    % NOTE: we need the hermite polynomials here to compute the moments,
    M(j+1)=sigma.^j.*hermite_val([zeros(1,j) 1],mu/sigma/1i).*(1i.^j);
end
m=M(n+1);
