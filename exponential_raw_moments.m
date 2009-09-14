function m=exponential_raw_moments(n, lambda)
% EXPONENTIAL_RAW_MOMENTS Compute raw moments of the exponential distribution.
%
% Example (<a href="matlab:run_example exponential_raw_moments">run</a>)
%   m=exponential_raw_moments( 0:5, 1.3 )
%
% See also EXPONENTIAL_MOMENTS

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


m=factorial(n).*lambda.^-n;
