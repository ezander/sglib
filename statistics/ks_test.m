function [reject,ksval,critval]=ks_test( cdf, x_samp, alpha )
% KS_TEST Perform the Kolmogorov-Smirnov test on the samples distribution.
%   [REJECT,KSVAL,CRIT]=KS_TEST( CDF, X_SAMP, ALPHA ) performs the Kolmogorov-
%   Smirnov test on the the the sampled distribution given in X_SAMP. ALPHA
%   is the level of confidence and is optional; if not supplied a default
%   value of 0.05 is used. CDF can be a handle to a function that
%   implements the cumulative distribution function against which the data
%   is tested, or it can consist of a two column vector in which the first
%   column contains the x values of the distribution and the second column
%   the corresponding values of the cdf. KSVAL is the test statistics of
%   the Kolmogorov-Smirnov test, and REJECT is a boolean value which
%   indicates whether the null hypothesis should be rejected with the
%   current significance level (i.e. the distributions seem not to match).
%   In ALPHA*100 per cent of all cases the hypothesis is rejected in spite
%   of them in fact being equal. CRIT is the critical value associated with
%   the value of ALPHA and the sample size.
%
% References:
%    [1] Miller, L.H., "Table of Percentage Points of Kolmogorov Statistics",
%        Journal of the American Statistical Association, (1951), 111-121.
%    [2] Knuth, Donald E. "The Art of Computer Programming - Vol. 2"
%
% Example (<a href="matlab:run_example ks_test">run</a>)
%    % test the quality of matlabs gaussian random numbers
%    n=10000;
%    norm_cdf=@(x)(1/2*(1+erf(x/sqrt(2))));
%    x_samp=randn(n,1);
%    [reject]=ks_test( norm_cdf, x_samp );
%    disp(reject); % will be 1 in approx. 5% of all runs if randn
%    % generates good normal random numbers, otherwise higher
%
% See also

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


if nargin<3
    alpha=0.05;
end

x_samp=sort(x_samp(:));
y=linspace(0,1,1+length(x_samp))';
if isfunction(cdf)
    y_samp=cdf(x_samp);
else
    cdf=[-inf 0; cdf; inf 1];
    [xval,ind]=unique(cdf(:,1));
    y_samp=interp1( xval, cdf(ind,2), x_samp );
end
ks=max(abs([y_samp-y(1:end-1);y_samp-y(2:end)]));

% use Miller's formula (exact only for n>20 and certain alpha range)
alpha1=alpha/2; % we are using two sided version

n = length(x_samp);
A = 0.09037*(-log10(alpha1))^1.5 + 0.01515*log10(alpha1)^2 - 0.08467*alpha1 - 0.11143;
asymp_stat = sqrt(-0.5*log(alpha1)/n);
crit = asymp_stat - 0.16693/n - A/n^1.5;
crit = min(crit, 1 - alpha1);

reject=ks>crit;
if nargout>1
    ksval=ks;
end
if nargout>2
    critval=crit;
end
