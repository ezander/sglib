function y=lognormal_pdf( x, mu, sigma )
% LOGNORMAL_PDF Probability distribution function of the lognormal distribution.
%   Y=LOGNORMAL_PDF( X, MU, SIGMA ) computes the pdf for the lognormal for
%   all values in X, which may be a vector. MU and SIGMA can be specified
%   optionally.
%
% Example (<a href="matlab:run_example lognormal_pdf">run</a>)
%   x=linspace(-10,20);
%   f=lognormal_pdf(x,2,.5);
%   F=lognormal_cdf(x,2,.5);
%   plot(x,f,x(2:end)-diff(x(1:2)/2),diff(F)/(x(2)-x(1)))
%
% See also LOGNORMAL_CDF


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
    mu=0;
end
if nargin<3
    sigma=1;
end

y=zeros(size(x));
ind=(x>0);
y(ind)=exp( -(log(x(ind))-mu).^2/(2*sigma^2) )./(sqrt(2*pi)*sigma*x(ind));
