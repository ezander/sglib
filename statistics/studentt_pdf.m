function y=studentt_pdf( x, nu )
% STUDENTT_PDF Probability distribution function of the Student_T distribution.
%   Y=STUDENTT_PDF( X, N ) computes the pdf for the Student_T distribution
%   with N degrees of freedeom for all values in X, which may be a vector.
%
% Example (<a href="matlab:run_example studentt_pdf">run</a>)
%   x=linspace(-4,4);
%   f3=studentt_pdf(x,3);
%   f5=studentt_pdf(x,5);
%   f10=studentt_pdf(x,10);
%   finf=normal_pdf(x);
%   plot(x,f3,x,f5,x,f10,x,finf);
%
% See also STUDENTT_CDF

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

y = 1 / (sqrt(nu) * beta(1/2, nu/2)) * ((1 + x.^2/nu).^(-(nu+1)/2));
