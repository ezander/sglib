function y=beta_pdf( x, a, b )
% BETA_PDF Probability distribution function of the beta distribution.
%   Y=BETA_PDF( X, A, B ) computes the pdf for the beta distribution for
%   all values in X, which may be a vector.
%
% Example (<a href="matlab:run_example beta_pdf">run</a>)
%   x=linspace(-0.2,1.2);
%   f=beta_pdf(x,2,3);
%   F=beta_cdf(x,2,3);
%   plot(x,f,x(2:end)-diff(x(1:2)/2),diff(F)/(x(2)-x(1)));
%
% See also BETA_CDF


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
%ind=(x>0)&(x<1);
ind=(x>=0)&(x<=1);
y(ind)=x(ind).^(a-1).*(1-x(ind)).^(b-1) / beta(a,b);
