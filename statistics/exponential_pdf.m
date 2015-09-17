function y=exponential_pdf( x, lambda )
% EXPONENTIAL_PDF Probability distribution function of the exponential distribution.
%   Y=EXPONENTIAL_PDF( X, LAMBDA ) computes the pdf for the exponential distribution for
%   all values in X, which may be a vector.
%
% Example (<a href="matlab:run_example exponential_pdf">run</a>)
%   x=linspace(-0.2,3);
%   f=exponential_pdf(x,1.3);
%   F=exponential_cdf(x,1.3);
%   plot(x,f,x(2:end)-diff(x(1:2)/2),diff(F)/(x(2)-x(1)));
%
% See also EXPONENTIAL_CDF

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


y=zeros(size(x));
ind=(x>=0);
y(ind)=lambda*exp(-lambda*x(ind) );
