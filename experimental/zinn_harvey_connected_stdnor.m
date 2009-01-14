function y=zinn_harvey_connected_stdnor( x, eps, high_connected )
% ZINN_HARVEY_CONNECTED_STDNOR Transforms standard normal random numbers with the Zinn Harvey transform.
%   Y=ZINN_HARVEY_CONNECTED_STDNOR( X, EPS, HIGH_CONNECTED ) transforms
%   standard normal (i.e. N(0,1)) distributed random numbers into by the
%   Zinn-Harvey transform (see paper). The result is again normally
%   distributed, but applying this transform to standard normal Gaussian
%   field gives a field in which the extreme values are connected. If
%   HIGH_CONNECTED is true or not specified high values are connected,
%   otherwise low values. 
%
%   EPS specifies a smoothing parameter, that regularizes the transformed
%   output. If EPS>0 the output is not standard normal anymore but the
%   transformation if then in L2 and can thus be PC expanded. For EPS=0 the
%   output is standard normal, but has a singularity at 0 and is thus not
%   in L2.
%
% Example
%   N=10000;
%   x=randn(N,1);
%   y=zinn_harvey_connected_stdnor(x,0.001,false);
%   kernel_density(y,100,0.25);
%
% See also 

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


sqrt2=1.4142135623730951;
sqrt2inv=0.7071067811865476;
if nargin<2
    eps=0;
end
if nargin<3
    high_connected=true;
end
if high_connected
    sign=-1;
else
    sign=1;
end
y=sign*sqrt2*erfinv( (1-eps)*(2*erf(abs(x)*sqrt2inv) - 1) );


%TODO: for larger x values the formula becomes very inaccurate and does not
%even gives results for abs(x)>8  

% the following code corrects this for eps very small and
% high_connected=true
% % limit=3.0;
% % ind=abs(x)<=limit;
% % y=x;
% % y(ind)=sign*sqrt(2)*erfinv( (1-eps)*(2*erf(abs(x(ind))*sqrt2inv) - 1) );
% % alpha=1/(limit*(limit-sign*sqrt(2)*erfinv( (1-eps)*(2*erf(abs(limit)*sqrt2inv) - 1) )))
% % y(~ind)=sign*abs(x(~ind))-1./(alpha*abs(x(~ind)));
