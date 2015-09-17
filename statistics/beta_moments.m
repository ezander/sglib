function [mean,var,skew,kurt]=beta_moments(a,b)
% BETA_MOMENTS Compute moments of the beta distribution.
%   [MEAN,VAR,SKEW,KURT]=BETA_MOMENTS( A, B ) computes the moments of the
%   beta distribution.
%
% Example (<a href="matlab:run_example beta_moments">run</a>)
%   [mean,var]=beta_moments(a,b);
%
% See also BETA_CDF, BETA_PDF


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


mean=a/(a+b);
if nargout>=2
    var=a*b/...
        ( (a+b)^2*(a+b+1) );
end
if nargout>=3
    skew=2*(b-a)*sqrt(a+b+1)/...
        ( (a+b+2)*sqrt(a*b) );
end
if nargout>=4
    kurt=6*(a^3-a^2*(2*b-1)+b^2*(b+1)-2*a*b*(b+2))/...
        (a*b*(a+b+2)*(a+b+3));
end
