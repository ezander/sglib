function [mean,var,skew,kurt]=exponential_moments(lambda)
% EXPONENTIAL_MOMENTS Compute moments of the exponential distribution.
%   [MEAN,VAR,SKEW,KURT]=EXPONENTIAL_MOMENTS( LAMBDA ) computes the moments of the
%   exponential distribution.
%
% Example (<a href="matlab:run_example exponential_moments">run</a>)
%   [mean,var]=exponential_moments( 1.3 );
%
% See also EXPONENTIAL_CDF, EXPONENTIAL_PDF

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


mean=1/lambda;
if nargout>=2
    var=1/lambda^2;
end
if nargout>=3
    skew=2;
end
if nargout>=4
    kurt=6;
end
