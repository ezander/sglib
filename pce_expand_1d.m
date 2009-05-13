function [pce_coeff,pce_ind,poly_coeff]=pce_expand_1d( func, p )
% PCE_EXPAND_1D Calculate the PCE expansion in one stochastics dimension.
%   [PCE_COEFF,PCE_IND,POLY_COEFF]=PCE_EXPAND_1D( F, P ) gives the polynomial
%   chaos expansion of a random variable X with X=f(gamma), i.e. the
%   random variable must be a transformed gaussian random variable. For
%   example for a lognormal random variable f=exp. This is possible for
%   an arbitrary random variable by specifying f(x)=F^-1(Phi(x)) where  F
%   and Phi are the cumulative density function of the expanded random
%   variable and the gaussian rv respectively. p is the order of the
%   expansion, thus the returned arrrays have dimension p+1. In PCE_COEFF
%   are the coefficients of the Hermite polynomials in the expansion such
%   that HERM_COEFF(i) is the coefficient of H_{PCE_IND(i)}. In POLY_COEFF are the
%   coefficients of the fully expanded polynomial in Matlab standard order
%   such that poly_coeff(p+1-i) is the coefficient of x^i. The polynomials
%   can most easily be evaluted at some point x by polyval(poly_coeff,x).
%   The algorithm uses numerical quadrature to evaluate the coefficients,
%   where the integration range is limited to [-20,20] since the integral
%   kernel should be sufficiently zero outside for all sensible values of
%   p. (Still the quadrature method should be improved to use maybe
%   Gauss-Hermit integration).
%
% Note:
%   PCE_IND is somehow unnecessary for a univariate PC expansion, it's
%   just there to make it more compatible with the multivariate PC
%   expansions, and to let you easily feed in results from this function
%   into functions that take multivariate PCEs.
%
% Example (<a href="matlab:run_example pce_expand_1d">run</a>)
%   [pcc,pci,poc]=pce_expand_1d( @exp, 4 );
%   x=linspace(-1,1); y=hermite_val(pcc,x);
%   plot(x,y);
%   disp(pcc);
%   disp(exp(1/2)./factorial(0:4)); % should be the same
%
% See also PCE_EXPAND_1D_MC

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


if nargin==0
    func=@exp;
    p=4;
end

global int_func h
int_func=func;

pce_coeff=zeros(1,p+1);
if nargout>1
    poly_coeff=zeros(1,p+1);
end

for i=0:p
    h=hermite(i);
    if 0 
        pce_coeff(i+1)=quad(@int_kernel,-20,20)/factorial(i);
    else
        % TODO: the order of the gauss_hermite method should depend on the
        % order of the coefficient being computed
        pce_coeff(i+1)=gauss_hermite(@int_kernel_gh,2*max(p,1)+2)/factorial(i);
        %pce_coeff(i+1)=gauss_hermite(@int_kernel_gh,12)/factorial(i);
    end
    if nargout>=3
        poly_coeff(p-i+1:p+1)=poly_coeff(p-i+1:p+1)+pce_coeff(i+1)*h;
    end
end

if nargout>=2
    pce_ind=(0:p)';
end

function y=int_kernel(x)
% INT_KERNEL evaluate the integral kernel of the gauss integral at location x.
global int_func h
y=funcall( int_func, x).*polyval(h,x).*exp(-x.^2/2)/sqrt(2*pi);

function y=int_kernel_gh(x)
% INT_KERNEL_GH evaluate the integral kernel for gauss hermite integration.
global int_func h
y=funcall( int_func, x).*polyval(h,x);
