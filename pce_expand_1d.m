function [pce_coeff,pce_ind]=pce_expand_1d( func, p )
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
    unittest_pce_expand_1d;
    return
end

pce_coeff=zeros(1,p+1);
pce_ind=(0:p)';

for i=0:p
    h=hermite(i);
    int_func={@int_kernel, {func, h}, {1, 2}};
    order=2*max(p,1)+2;
    pce_coeff(i+1)=gauss_hermite(int_func,order)/factorial(i);
end

function y=int_kernel(int_func, h, x)
% INT_KERNEL evaluate the integral kernel for gauss hermite integration.
y=funcall( int_func, x).*polyval(h,x);
