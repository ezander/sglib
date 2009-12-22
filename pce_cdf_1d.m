function y=pce_cdf_1d( x, X_alpha, I_X )
% PCE_CDF_1D Compute cumulative distribution for univariate PCE.
%   PCE_CDF_1D Long description of pce_cdf_1d.
%
% Example (<a href="matlab:run_example pce_cdf_1d">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if ~size(I_X,2)==1
    error( 'pce_cdf_1d:dim_error', 'function works only for univariate PCE variables' )
end


n=size(X_alpha,1)-1;
h=hermite( n, true );
p=X_alpha'*h;

y=x;
for i=1:length(x(:))
    q=p;
    q(end)=q(end)-x(i);
    r=roots( q );
    r=sort(r(imag(r)==0));
    
    sign_minf=sign(p(1))*(1-2*mod(n,2));
    if sign_minf<0
        r=[-inf; r]; %#ok<AGROW>
    end
    
    sign_inf=sign(p(1));
    if sign_inf<0
        r=[r; inf]; %#ok<AGROW>
    end
    
    y(i)=0;
    for k=1:2:length(r)
        y(i)=y(i)+normal_cdf(r(k+1))-normal_cdf(r(k));
    end
end
