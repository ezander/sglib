function [pce_coeff,pce_ind,poly_coeff]=pce_expand_1d_mc( f, p )
% PCE_EXPAND_1D_MC Calculate the PCE expansion in one stochastics dimension (MC).
%    [HERM_COEFF,POLY_COEFF]=PCE_EXPAND_1D( F, P ) gives the polynomial
%    chaos expansion of a random variable X with X=F(gamma). See
%    pce_expand_1d_mc. F can also be a vector of samples from the unknown
%    distribution; in this case the empirical CDF of the distribution is
%    inferred by sorting the samples.
%    For more info on the returned value see PCE_EXPAND_1D.
%
% Example (<a href="matlab:run_example pce_expand_1d_mc">run</a>)
%    N=10000;
%    h=@(x)(exp(3+0.5*x));
%    nor=randn(N,1);
%    lognor_data=h(randn(N*10,1));
%    pcc=pce_expand_1d_mc(lognor_data,7);
%    x=linspace(-1,1); y=hermite_val(pcc,x);
%    plot(x,y);
%
% See also PCE_EXPAND_1D

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


global fp h
fp=f;

pce_coeff=zeros(1,p+1);
if nargout>1
    poly_coeff=zeros(1,p+1);
end

if isfunction(f)
    Ns=100000;
    gam=randn(Ns,1);
    fgam=f(gam);
else
    fgam=sort(f(:));
    Ns=length(fgam);
    uni=linspace(0,1,Ns+2)';
    uni=uni(2:end-1);
    gam=sqrt(2)*erfinv(2*uni-1);
end

for i=0:p
    h=hermite(i);
    hgam=polyval(h,gam);
    pce_coeff(i+1)=sum( fgam.*hgam )/sum( hgam.^2 );
    if nargout>1
        poly_coeff(p-i+1:p+1)=poly_coeff(p-i+1:p+1)+pce_coeff(i+1)*h;
    end
end

if nargout>=2
    pce_ind=multiindex(1,p);
end
