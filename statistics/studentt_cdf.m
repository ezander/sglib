function y=studentt_cdf( x, nu )
% STUDENTT_CDF Cumulative distribution function of the Student_T distribution.
%   Y=STUDENTT_CDF( X, N ) computes the cdf for the Student_T distribution
%   with N degrees of freedom for all values in X, which may be a vector.
%
% Example (<a href="matlab:run_example studentt_cdf">run</a>)
%   x=linspace(-4,4);
%   F3=studentt_cdf(x,3);
%   F5=studentt_cdf(x,5);
%   F10=studentt_cdf(x,10);
%   Finf=normal_cdf(x);
%   plot(x,F3,x,F5,x,F10,x,Finf);
%
% See also STUDENTT_PDF

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

z = nu ./ (x.^2 + nu);
y=0.5 * (1 + sign(x) .* (1 - betainc(z, nu/2, 1/2)));
