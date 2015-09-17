function [mean,var,skew,kurt]=chisquared_moments(k)
% CHISQUARED_MOMENTS Compute moments of the chisquared distribution.
%   [MEAN,VAR,SKEW,KURT]=CHISQUARED_MOMENTS( MU, SIGMA ) computes the moments of the
%   chisquared distribution.
%
% References:
%   [1] http://en.wikipedia.org/wiki/Chi-squared_distribution
%   [2] http://mathworld.wolfram.com/Chi-SquaredDistribution.html
%
% Example (<a href="matlab:run_example chisquared_moments">run</a>)
%   [mean,var,skew,kurt]=chisquared_moments(5);
%   fprintf('Exact moments\nmean=%g, var=%g, skew=%g,kurt-ex=%g\n',mean,var,skew,kurt);
%
%   N=1000000; x=chisquared_sample(N,5);
%   [mean,var,skew,kurt]=data_moments(x);
%   fprintf('Moments from %d samples\nmean=%g, var=%g, skew=%g,kurt-ex=%g\n',N,mean,var,skew,kurt);
%
% See also CHISQUARED_CDF, CHISQUARED_PDF
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

mean=k;
if nargout>=2
    var=2*k;
end
if nargout>=3
    skew=sqrt(8/k);
end
if nargout>=4
    kurt=12/k;
end
