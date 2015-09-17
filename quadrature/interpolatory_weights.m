function w=interpolatory_weights(x, varargin)
% INTERPOLATORY_WEIGHTS Compute interpolatory weights for integration rules.
%   INTERPOLATORY_WEIGHTS(X) computes interpolatory weights for an
%   integration rule with Lebesgue measure where an integration interval of
%   [-1, 1] is assumed. It is not checked that the values in X lie within
%   that interval.
%   Note that the Gauss, Clenshaw-Curtis and Fejer rules don't use this
%   method to compute their weights, but have specialised method of their
%   own.
%
% Note: The code currently works by computing the Lagrange polynomial for
%   each node and integrating that over the domain, which can be done
%   exactly and easily for polynomials. TODO: however, better would
%   probably be to implement the algorithm in [1], at least if we want to
%   go to really high orders.
%
% References
%    [1] J. Kautsky and S. Elhay, Calculation of the weights of
%        interpolatory quadratures, Numer. Math., 40 (1982), pp. 407–422.
%
% Example (<a href="matlab:run_example interpolatory_weights">run</a>)
%   % generate closed Newton-Cotes rule with seven points
%   x=linspace(-1, 1, 5);
%   w=interpolatory_weights(x);
%   % show nodes and weights
%   underline('Nodes and weights');
%   fprintf('nodes:   %s\n', rats(x))
%   fprintf('weights: %s\n\n', rats(w'))
%   % integrate cos over [-1,1] with this rule and compare to analytical
%   underline('Integrate cos on [-1,1]');
%   fprintf('numerical:  %g\n', cos(x)*w);
%   fprintf('analytical: %g\n', sin(1)-sin(-1));
%
% See also NEWTON_COTES_RULE

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

options=varargin2options(varargin);
[algorithm,options]=get_option(options, 'algorithm', 'lagrange');
%[algorithm,options]=get_option(options, 'algorithm', 'vandermonde');
[I,options]=get_option(options, 'interval', [-1,1]);
check_unsupported_options(options,mfilename);

a=I(1);
b=I(2);
if a~=-1 || b~=1
    f=(b-a)/2;
    x=(x-(b+a)/2)/f;
else
    f=1;
end

switch lower(algorithm)
    case 'lagrange'
        w=weights_lagrange(x);
    case 'vandermonde'
        w=weights_vandermonde(x);
    otherwise
        error('sglib:argument', 'Unknown algorithm: %s', algorithm);
end
w=w*f;

function w=weights_lagrange(x)
%% WEIGHTS_LAGRANGE Compute weights via Lagrange polynomials
w = zeros(size(x'));
for k=1:length(w)
    xk = x;
    xk(k)=[];
    p=poly(xk);
    q=polyint(p/polyval(p,x(k)));
    w(k)=polyval(q,1)-polyval(q,-1);
end

function w=weights_vandermonde(x)
%% NC_WEIGHTS_VANDER Compute weights via Vandermonde matrix
% int_-1^1 x^n = (1^(n+1) - (-1)^(n+1))/(n+1) = sum_i w_i x_i^n
n1=(1:length(x))';
m=(1 - (-1).^n1)./n1;
V=binfun(@power, x, n1-1);
w=V\m;
