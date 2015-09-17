function [x,w]=clenshaw_curtis_rule(n, varargin)
% CLENSHAW_CURTIS_RULE Compute nodes and weights of the Clenshaw-Curtis rules.
%   [X,W]=CLENSHAW_CURTIS_RULE(N) returns the nodes and weights of the N
%   point Clenshaw-Curtis rule, or of Fejer's first or second rule, is the
%   'mode' option was set accordingly. N must be an integer larger or equal
%   to 1.
%   
% Note: There is no one-point Clenshaw-Curtis rule. However, for the nested
%   Clenshaw-Curtis used in sparse grid methods, the midpoint rule is
%   usually used for the first stage, instead of the CC 2 rule, which is
%   equivalent to the trapezoidal rule. The midpoint rule has the same
%   order of accuracy but leads to fewer nodes in high dimesions (see e.g.
%   [3]). 
%
% Options
%   'mode': {'cc'}, 'fejer1', 'fejer2'
%     Selects the actual integration rule from Clenshaw-Curtis, Fejer 1 or
%     Fejer 2. Fejer 1 and 2 don't include the end points of the interval
%     of integration and are better suited if there are singularities.
%   'interval': [-1, 1]
%      Must be a double array of length 2, specifying the interval on which
%      the Clenshaw-Curtis or Fejer rule is to be computed.
%
% References
%   [1] J. Waldvogel: Fast Construction of the Fejer and Clenshaw-Curtis
%       Quadrature Rules, BIT (46) 2006, pp 195-202
%       doi: 10.1007/s10543-006-0045-4
%   [2] G. von Winckel: http://www.scientificpython.net/1/post/2012/04/clenshaw-curtis-quadrature.html
%   [3] K. Petra: Asymptotically minimal Smolyak Cubature,
%       http://http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.33.2432 
%
% Example (<a href="matlab:run_example clenshaw_curtis_rule">run</a>)
%   % Integrate a continuous function on [-1,1]
%   [x, w] = clenshaw_curtis_rule(10);
%   I=cos(pi*x/2)*w
%   Iex=4/pi
%   % Integrate a function with singularities at -1 and 1
%   [x, w] = clenshaw_curtis_rule(20, 'mode', 'fejer1');
%   I=abs(x)./sqrt(1-x.^2)*w
%   Iex=2
%
% See also CLENSHAW_CURTIS_NESTED, SMOLYAK_GRID

%   Elmar Zander
%   Copyright 2013-2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

   
options=varargin2options(varargin, mfilename);
[mode, options]=get_option(options, 'mode', 0);
[I,options]=get_option(options, 'interval', []);
check_unsupported_options(options)

switch mode
    case {'cc', 0}
        mode=0;
    case {'fejer1', 1}
        mode=1;
    case {'fejer2', 2}
        mode=2;
    otherwise
        error('sglib:invalid_argument', strvarexpand('Unknown mode "$mode$" for clenshaw_curtis'));
end

n1 = n + mode - 1;
x=cc_fejer_nodes(n1, mode);
if n < 3
    nx = length(x);
    w = 2 * ones(nx, 1) / nx;
else
    w = cc_fejer_weights(n1, mode);
end

if ~isempty(I)
    [x, w] = shift_quad_interval(I, x, w);
end


function x = cc_fejer_nodes(n, mode)
% Using the sin on -pi/2 to pi/2 gives slightly better results than the
% cos on  0 to pi (more symmetric)
switch mode
    case {'cc', 0}
        k = 0:n;
        if n==0
            x = 0; return;
        end
    case {'fejer1', 1}
        k = (1:n) - 1/2;
    case {'fejer2', 2}
        k = (1:n-1);
end
x = sin(pi * (k / n - 0.5));


function w = cc_fejer_weights(n, mode)
% Wrapper around the fejer routine from J. Waldvogel
[wf1,wf2,wcc] = fejer(n);
switch mode
    case {'cc', 0}
        w = [wcc; wcc(1)];
    case {'fejer1', 1}
        w = wf1;
    case {'fejer2', 2}
        w = wf2(2:end);
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
