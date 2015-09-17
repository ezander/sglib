function [mean,var,skew,kurt]=lognormal_moments(mu,sigma)
% LOGNORMAL_MOMENTS Compute moments of the lognormal distribution.
%   [MEAN,VAR,SKEW,KURT]=LOGNORMAL_MOMENTS( MU, SIGMA ) computes the moments of the
%   lognormal distribution.
%
% References:
%   [1] http://en.wikipedia.org/wiki/Log-normal_distribution
%   [2] http://mathworld.wolfram.com/LogNormalDistribution.html
%
% Example (<a href="matlab:run_example lognormal_moments">run</a>)
%   [mean,var]=lognormal_moments(mu,sigma);
%
% See also LOGNORMAL_CDF, LOGNORMAL_PDF
%

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

mean=exp(mu+sigma^2/2);
if nargout>=2
    var=(exp(sigma^2)-1)*exp(2*mu+sigma^2);
end
if nargout>=3
    %The following from wikipedia is probably buggy
    % skew=exp(-mu-sigma^2/2)*(exp(sigma^2)+2)*sqrt(exp(sigma^2)-1);
    %The next from mathworld performs better
    skew=(exp(sigma^2)+2)*sqrt(exp(sigma^2)-1);
end
if nargout>=4
    kurt=exp(4*sigma^2)+2*exp(3*sigma^2)+3*exp(2*sigma^2)-6;
end
