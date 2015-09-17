function [mean,var,skew,kurt]=uniform_moments(a,b)
% UNIFORM_MOMENTS Compute moments of the uniform distribution.
%   [MEAN,VAR,SKEW,KURT]=UNIFORM_MOMENTS( A, B) computes the moments of the
%   uniform distribution. A and B default to 0 and 1 respectively.
%
% Example (<a href="matlab:run_example uniform_moments">run</a>)
%   [mean,var]=uniform_moments(2,4);
%
% See also UNIFORM_CDF, UNIFORM_PDF

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


if nargin<1
    a=0;
end
if nargin<2
    b=1;
end

mean=0.5*(a+b);
if nargout>=2
    var=(b-a)^2/12;
end
if nargout>=3
    skew=0;
end
if nargout>=4
    kurt=-6/5;
end
