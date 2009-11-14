function cg_conv
% CG_CONV Short description of cg_conv.
%   CG_CONV Long description of cg_conv.
%
% Example (<a href="matlab:run_example cg_conv">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

clc
contract( 8, 1 )
contract( 9, 1 )
contract( 33, 2 )
contract( 34, 2 )
contract( 75, 3 )
contract( 76, 3 )
contract( 133, 4 )
contract( 134, 4 )
%contract( 76, 3 )

k=1:100;
kappa=inv_contract(k);
hold off
plot(log(k),log(kappa),'x')
[m,n]=polyfit(log(k),log(kappa),1);
hold on
plot(log(k),m(2)+m(1)*log(k),'r-')
plot(log(k),log(4/log(2)^2)+2*log(k),'g-')
hold off
keyboard
plot(k,kappa,'x')
[m,n]=polyfit(log(k),log(kappa),1);
hold on
plot(k,exp(m(2))*k.^m(1),'r-')
%plot(k,9/1.08*k.^2,'g-')
plot(k,4/log(2)^2*k.^2,'g-')

function rho=contract(kappa,k)
rho=2*((sqrt(kappa)-1)./(sqrt(kappa)+1)).^k;

function kappa=inv_contract(k)
% e^t=kappa^(1/4)
t=atanh(0.5.^(1./k));
kappa=exp(4*t);
kappa=exp(4*atanh(0.5.^(1./k)));


