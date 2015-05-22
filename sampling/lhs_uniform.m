function U=lhs_uniform(n, m, varargin)
% LHS_UNIFORM Generate uniform Latin hypercube samples.
%   U=LHS_UNIFORM(N, M) generates N Latin hypercube samples for each of M
%   uniformly distributed random variables returned. That is, each of the M
%   returned columns contains N uniformly distributed points.
%
% References:
%   [1] McKay, M.D., Beckman, R.J., Conover, W.J.: "A Comparison
%       of Three Methods for Selecting Values of Input Variables in the
%       Analysis of Output from a Computer Code", Technometrics 21 (2)
%       1979, pp. 239–245, doi:10.2307/1268522
%   [2] http://en.wikipedia.org/wiki/Latin_hypercube_sampling
%
% Example (<a href="matlab:run_example lhs_uniform">run</a>)
%   n=7;
%   x = lhs_uniform(n, 2);
%   plot(x(:,1), x(:,2), 'rx', 'MarkerSize', 10);
%   axis square
%   lhs_plot_grid(n)
%
% See also RAND, RANDPERM

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

options=varargin2options(varargin, mfilename);
[mode, options]=get_option(options, 'mode', 'rand');
check_unsupported_options(options);

U = zeros(n, m);
for i =1:m
    U(:,i) = lhs_sample_1d(n, mode);
end
    

function x=lhs_sample_1d(n, mode)
k = (randperm(n)-1);
switch(mode)
    case {'rand', 'rlhs'}
        dx = rand(n,1);
    case {'median', 'mlhs'}
        dx = repmat(0.5, n, 1);
    otherwise
        error('sglib:lhs_uniform', 'Unknown mode for LHS: %s', mode);
end
x = (k(:) + dx)/n;
