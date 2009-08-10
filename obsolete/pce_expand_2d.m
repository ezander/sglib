function [pce_coeff,pce_herm_ind]=pce_expand_2d( f, p )
% PCE_EXPAND_2D Calculate the PCE expansion in two stochastics dimensions.
%   
%
% Example (<a href="matlab:run_example pce_expand_2d">run</a>)
%   [pce_coeff,pce_h_ind]=pce_expand_2d( @(x,y)(exp(x+y)), 4 );
%
% See also PCE_EXPAND_1D

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id: pce_expand_2d.m 316 2009-07-16 12:05:58Z ezander $ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% WARNING: Probably this function is nonsense, have to rethink it


global fp h1 h2

if nargin==0
    f=@(x,y)(exp(x+y));
    p=1;
end

A=multiindex( 2, p );
n_pce=size(A,1);
pce_coeff=zeros(1,n_pce);
fp=f;

for i=1:n_pce
    alpha=full(A(i,:));
    h1=hermite(alpha(1));
    h2=hermite(alpha(2));
    tic
    if 1
        pce_coeff(i)=dblquad(@int_kernel,-20,20,-20,20)/prod(factorial(alpha));
    else
        pce_coeff(i)=gauss_hermite_multi(@int_kernel_gh,2,8)/prod(factorial(alpha));
    end
    toc
end
pce_herm_ind=A;


function z=int_kernel(x,y)
% INT_KERNEL evaluate the integral kernel of the gauss integral at location x.
global fp h1 h2
z=fp(x,y).*polyval(h1,x).*polyval(h2,y).*exp(-(x.^2+y.^2)/2)/(2*pi);

function z=int_kernel_gh(xy)
% INT_KERNEL evaluate the integral kernel of the gauss integral at location x.
global fp h1 h2
x=xy(1); y=xy(2);
z=fp(x,y).*polyval(h1,x).*polyval(h2,y);
