function x=studentt_invcdf(y, nu)
% STUDENTT_INVCDF Inverse CDF of the Student_T distribution.
%   X=STUDENTT_INVCDF( Y, N ) computes the inverse cumulative distribution
%   function of the Student_T distribution with N degrees of freedom for
%   the values in Y, which should all be in [0,1].
%
% Example (<a href="matlab:run_example studentt_invcdf">run</a>)
%   y=linspace(0.025,0.975);
%   x3=studentt_invcdf(y,3);
%   x5=studentt_invcdf(y,5);
%   x10=studentt_invcdf(y,10);
%   xinf=normal_invcdf(y);
%   plot(y,x3,y,x5,y,x10,y,xinf);
%
% See also STUDENTT_CDF, STUDENTT_PDF

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
x=nan(size(y));
ind = (y>=0) & (y<=1);

sy = sign(y(ind)-0.5);
ay = abs(y(ind) - 0.5);
z = inv_reg_beta(1 - 2 * ay, nu/2, 1/2);
x(ind) = sy .* sqrt(nu ./ z - nu);
