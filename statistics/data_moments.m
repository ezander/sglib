function [mean,var,skew,kurt]=data_moments( x )
% DATA_MOMENTS Compute moments of given data.
%   [MEAN,VAR,SKEW,KURT]=DATA_MOMENTS( X ) computes the moments of the
%   data given in X. The unbiased estimators are used here.
%
% Example (<a href="matlab:run_example data_moments">run</a>)
%   x=3+2*randn(10000,1);
%   [mean,var,skew,kurt]=data_moments( x );
%   [mean-3,var-4,skew-0,kurt-0]
%   y=exp(x); %transform to lognormal
%   [mean,var,skew,kurt]=data_moments( y );
%   [exp(5),(exp(4)-1)*exp(10),0,0]
%   [mean,var,skew,kurt]
%   [mean-exp(5),var-(exp(4http://mathworld.wolfram.com/SampleVarianceComputation.html)-1)*exp(10),skew,kurt]
%
% Note
%   There is a more stable algorithm availabel at
%   http://mathworld.wolfram.com/SampleVarianceComputation.html
%   but that one is too slow to implement in matlab. Better in C/C++.
%
% See also PCE_MOMENTS, LOGNORM_MOMENTS, NORMAL_MOMENTS

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

x=x(:);
n=length(x);
mean=sum(x)/n;
if nargout>=2
    % unbiased estimator
    var=sum((x-mean).^2)/(n-1);
    % biased, but better in a least squares sense. use this one?
    % var=sum((x-mean).^2)/n;
end
if nargout>=3
    % sample skewness
    g1=1/n*sum((x-mean).^3)/var^(3/2);
    % unbiased estimator
    skew=sqrt(n*(n-1))/(n-2) * g1;
end
if nargout>=4
    % sample kurtosis (yeah, the -3 is correct...)
    g2=1/n*sum((x-mean).^4)/var^2-3;
    % excess kurtosis
    kurt=(n-1)*((n+1)*g2+6)/((n-2)*(n-3));
end
