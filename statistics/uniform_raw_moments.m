function m=uniform_raw_moments(n,a,b)
% UNIFORM_RAW_MOMENTS Compute raw moments of the uniform distribution.
%
% Example (<a href="matlab:run_example uniform_raw_moments">run</a>)
%   m=uniform_raw_moments( 0:5, 1, 2 )
%
% See also UNIFORM_MOMENTS

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
    a=0;
end
if nargin<3
    b=1;
end

if a~=b
    m=(a.^(n+1)-b.^(n+1))/(a-b)./(n+1);
else
    % this case may be a bit pointless, but anyway, we cover it here
    m=a.^n;
end
