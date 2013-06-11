function y=uniform_cdf( x, a, b )
% UNIFORM_CDF Cumulative distribution function of the uniform distribution.
%   Y=UNIFORM_CDF( X, A, B ) computes the cdf for the uniform distribution for
%   all values in X, which may be a vector. A and B can be specified
%   optionally, otherwise they default to 0 and 1.
%
% Example (<a href="matlab:run_example uniform_cdf">run</a>)
%   x=linspace(0,6,1000);
%   f=uniform_pdf(x,2,4);
%   F=uniform_cdf(x,2,4);
%   plot(x,F,x,cumsum(f)*(x(2)-x(1)) )
%
% See also UNIFORM_PDF

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


if nargin<2
    a=0;
end
if nargin<3
    b=1;
end

y=(x-a)/(b-a);
y(x<a)=0;
y(x>b)=1;
