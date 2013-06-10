function [x,w]=clenshaw_curtis_rule(n)
% CLENSHAW_CURTIS_RULE Compute nodes and weights of the Clenshaw-Curtis rules.
%   [X,W]=CLENSHAW_CURTIS_RULE(N) 
%
% References
%   [1] J. Waldvogel: Fast Construction of the Fejer and Clenshaw-Curtis
%       Quadrature Rules, BIT (46) 2006, pp 195-202
%       doi: 10.1007/s10543-006-0045-4
%
% Example (<a href="matlab:run_example clenshaw_curtis_rule">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if n == 1
    x = 0;
    w = 2;
elseif n == 2
    x = [-1, 1];
    w = [1; 1];
else
    x = sin(pi * linspace(-0.5, 0.5, n));
    w = cc_fejer_weights(n, 3);
end

function [x,w]=clencurt(n)
% Computes the Clenshaw Curtis nodes and weights
% Adapted a code by G. von Winckel
% http://www.scientificpython.net/1/post/2012/04/clenshaw-curtis-quadrature.html
% Problem for n==2
if n == 1
    x = 0;
    w = 2;
else
    C = zeros(n,2);
    k = 2*(1:floor((n-1)/2));
    C(1:2:end,1) = 2./[1, 1-k.*k];
    C(2,2) = -(n-1);
    V = [C; flipud(C(2:n-1,:))];
    F = real(ifft(V)); %, n=None, axis=0))
    x = F(1:n,2)';
    w = [F(1,1); 2*F(2:n-1,1); F(n,1)];
end


function w = cc_fejer_weights(n, mode)
[wf1,wf2,wcc] = fejer(n-1);
switch mode
    case 1
        w = wf1;
    case 2
        w = wf2(2:end);
    case 3
        w = [wcc; wcc(1)];
    otherwise
        error('foo');
end


function [wf1,wf2,wcc] = fejer(n)
% FEJER Computes Fejer and CC weights (taken from [1])
% Weights of the Fejer2, Clenshaw-Curtis and Fejer1 quadratures
% by DFTs. Nodes: x_k = cos(k*pi/n), n>1
N=(1:2:n-1)'; l=length(N); m=n-l; K=(0:m-1)';
% Fejer2 nodes: k=0,1,...,n; weights: wf2, wf2_n=wf2_0=0
v0=[2./N./(N-2); 1/N(end); zeros(m,1)];
v2=-v0(1:end-1)-v0(end:-1:2); wf2=ifft(v2);
%Clenshaw-Curtis nodes: k=0,1,...,n; weights: wcc, wcc_n=wcc_0
g0=-ones(n,1); g0(1+l)=g0(1+l)+n; g0(1+m)=g0(1+m)+n;
g=g0/(n^2-1+mod(n,2)); wcc=ifft(v2+g);
% Fejer1 nodes: k=1/2,3/2,...,n-1/2; vector of weights: wf1
v0=[2*exp(1i*pi*K/n)./(1-4*K.^2); zeros(l+1,1)];
v1=v0(1:end-1)+conj(v0(end:-1:2)); wf1=ifft(v1);
