function [m,n]=plot_linreg( x, y, varargin )
% PLOT_LINREG Short description of plot_linreg.
%   PLOT_LINREG Long description of plot_linreg.
%
% Example (<a href="matlab:run_example plot_linreg">run</a>)
%   x=linspace(2,5,30)+0.1*rand(1,30);
%   y=2.5*x+1+1.3*rand(1,30);
%   plot_linreg( x, y );
%   userwait;
%   x=exp(x);
%   plot_linreg( x, y, 'logx', true );
%   userwait;
%   plot_linreg( x, y, 'logx', true, 'log_axes', false );
%   userwait;
%   y=exp(y);
%   plot_linreg( x, y, 'logx', true, 'logy', true );
%   userwait;
%   plot_linreg( x, y, 'logx', true, 'logy', true, 'log_axes', false );
%   userwait;
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[logx,options]=get_option(options,'logx',false);
[logy,options]=get_option(options,'logy',false);
[log_axes,options]=get_option(options,'log_axes',true);
check_unsupported_options(options,mfilename);


if length(x)<100
    ptype='x';
else
    ptype='-';
end

[z,m,n]=dofit( x, y, logx, logy );
if log_axes
    plot( x, y, ptype, x, z, '-' );
    h=gca;
    if logx; set( h, 'xscale', 'log' ); end
    if logy; set( h, 'yscale', 'log' ); end
else
    x=logif(x,logx);
    y=logif(y,logy);
    z=logif(z,logy);
    plot( x, y, ptype, x, z, '-' );
end
 


function [z,m,n]=dofit( x, y, logx, logy )
x=logif(x,logx);
y=logif(y,logy);
a=polyfit(x,y,1);
z=polyval(a,x);
if logy; z=exp(z); end
m=a(1); n=a(2);

function t=logif( t, logt )
if logt; t=log(t); end
