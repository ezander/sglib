function [X_alpha,I]=pce_expand_1d( func, p )
% PCE_EXPAND_1D Calculate the PC expansion in one stochastics dimension.
%   [X_ALPHA,I]=PCE_EXPAND_1D( FUNC, P ) gives the polynomial chaos
%   expansion of a random variable X with X=FUNC(gamma), i.e. the random
%   variable must be a transformed Gaussian random variable. E.g. for a
%   lognormal random variable you would pass FUNC=@EXP (for some common
%   distributions those functions are given by XXX_STDNOR where XXX is the
%   name of the distribution). This is possible for an arbitrary random
%   variable by specifying F(x)=F^-1(Phi(x)) where  F and Phi are the
%   cumulative density function of the expanded random variable and the
%   Gaussian RV respectively. P is the order of the expansion, thus the
%   returned arrrays have dimension P+1. In X_ALPHA are the coefficients of
%   the Hermite polynomials in the expansion such that X_ALPHA(i) is the
%   coefficient of H_{I(i)}.
%
% Note:
%   I is somehow unnecessary for a univariate PC expansion, it's
%   just there to make it more compatible with the multivariate PC
%   expansions, and to let you easily feed in results from this function
%   into functions that take multivariate PCEs.
%
% Example (<a href="matlab:run_example pce_expand_1d">run</a>)
%   [Log_alpha,I]=pce_expand_1d( {@lognormal_stdnor, {0, 1}, {2, 3}}, 4 );
%   x=linspace(-1,1); y=hermite_val(Log_alpha,x);
%   plot(x,y);
%   disp(Log_alpha);
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

X_alpha=zeros(1,p+1);
I=(0:p)';
order=2*max(p,1)+2;

for i=0:p
    h=hermite(i);
    int_func={@int_kernel, {func, h}, {1, 2}};
    X_alpha(i+1)=gauss_hermite(int_func,order)/factorial(i);
end

function y=int_kernel(int_func, h, x)
% INT_KERNEL evaluate the pce integral kernel for gauss hermite integration.
y=funcall( int_func, x).*polyval(h,x);
