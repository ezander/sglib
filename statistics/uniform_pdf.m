function y=uniform_pdf( x, a, b )
% UNIFORM_PDF Probability distribution function of the uniform distribution.
%   Y=UNIFORM_PDF( X, A, B ) computes the pdf for the uniform for
%   all values in X, which may be a vector. A and B can be specified
%   optionally, otherwise they default to 0 and 1.
%
% Example (<a href="matlab:run_example uniform_pdf">run</a>)
%   x=linspace(0,6,1000);
%   f=uniform_pdf(x,2,4);
%   F=uniform_cdf(x,2,4);
%   plot(x,f,x(2:end)-diff(x(1:2)/2),diff(F)/(x(2)-x(1)))
%
% See also UNIFORM_CDF

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

y=repmat(1/(b-a),size(x));
y(x<a)=0;
y(x>b)=0;

