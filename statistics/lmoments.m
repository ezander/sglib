function m=lmoments(x, varargin)
% LMOMENTS Computes the L-moments of an set of samples.
%   LMOMENTS computes the first four L-moments of a set of samples given in
%   X. That means the L-mean, L-variance, L-skewness and L-kurtosis. 
%
% Options
%   ratios: false, {true}
%     If set to false the unscaled L-moments are returned. Otherwise, the
%     third and fourth moment are divided by the second L-moment (default).
%
% References
%   [1] http://en.wikipedia.org/wiki/L-moment
%
% Example (<a href="matlab:run_example lmoments">run</a>)
%   x = rand(10000, 1);
%   disp(lmoments(x));
%
% See also DEMO_LMOMENTS

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[ratios, options]=get_option(options, 'ratios', true);
check_unsupported_options(options, mfilename);


x = sort(x, 2);
n = size(x, 2);

m = zeros(size(x,1), 4);
i = 1:n;
for r = 1:4
    switch r
        case 1
            f = ones(1,n);
        case 2
            f = binom(i-1,1) - binom(n-i,1);
        case 3
            f = binom(i-1,2) - 2*binom(i-1,1).*binom(n-i,1) + binom(n-i,2);
        case 4
            f = binom(i-1,3) - 3*binom(i-1,2).*binom(n-i,1) + 3*binom(i-1,1).*binom(n-i,2) - binom(n-i,3);
    end
    m(:, r) = 1/(r * nchoosek(n, r)) * f * x';
end

if ratios
    m(:,3)=m(:,3)./m(:,2);
    m(:,4)=m(:,4)./m(:,2);
end


function b=binom(n, k)
switch k
    case 1
        b=n;
    case 2
        b=(1/2) * n .* (n-1);
    case 3
        b=(1/6) * n .* (n-1) .* (n-2);
    otherwise
        error('foo');
end
