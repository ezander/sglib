function [mean,var,skew,kurt]=normal_moments(mu,sigma)
% NORMAL_MOMENTS Compute moments of the normal distribution.
%   [MEAN,VAR,SKEW,KURT]=NORMAL_MOMENTS( MU, SIGMA ) computes the moments of the
%   normal distribution. This is of course pretty trivial but for
%   completenesses sake...
%
% Example (<a href="matlab:run_example normal_moments">run</a>)
%   [mean,var]=normal_moments(mu,sigma);
%
% See also NORMAL_CDF, NORMAL_PDF

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<1
    mu=0;
end
if nargin<2
    sigma=1;
end

mean=mu;
if nargout>=2
    var=sigma^2;
end
if nargout>=3
    skew=0;
end
if nargout>=4
    kurt=0;
end
