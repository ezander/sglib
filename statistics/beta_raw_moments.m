function m=beta_raw_moments(n, a, b)
% BETA_RAW_MOMENTS Compute raw moments of the beta distribution.
%
% Example (<a href="matlab:run_example beta_raw_moments">run</a>)
%   m=beta_raw_moments( 0:5, 2, 4 )
%
% See also BETA_MOMENTS

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

m=zeros(size(n));
for i=1:length(n(:));
    % m(i)=prod(a+(0:n(i)-1))/prod(a+b+(0:n(i)-1));
    m(i)=prod( (a+(0:n(i)-1)) ./ (a+b+(0:n(i)-1)) );
end
