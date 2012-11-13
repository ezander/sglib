function xi = gpc_sample(V, n)
% GPC_SAMPLE Draw samples from a GPC.
%   XI = GPC_SAMPLE(V, N) creates N rows and M columns of samples, where M
%   is the number of random variables. V contains a specification of the
%   random variables and a multiindex set (see Example). 
%
% Example (<a href="matlab:run_example gpc_sample">run</a>)
%    I = multiindex(3,2);
%    V = {'H', I};
%    xi = gpc_sample(V, 5)
%    V = {{'L', 'H', 'Ln'}, I};
%    xi = gpc_sample(V, 3000);
%    plot(xi(1,:), xi(2,:), '.')
%    xlabel('Uniform'); ylabel('Gauss');
%
% See also RAND, RANDN, GPC_EVALUATE

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

sys = V{1};
I = V{2};
m = size(I,2);

if nargin<2
    n = 1;
end

if iscell(sys)
    check_range(length(sys), m, m, 'len(sys)==m', mfilename);
    xi = zeros(m, n);
    for j = 1:m
        xi(j,:) = rv_sample(sys{j}, 1, n);
    end
else
    xi = rv_sample(sys, m, n);
end

function xi = rv_sample(sys, m, n)
switch sys
    case {'H', 'Hn'}
        xi = randn(m, n);
    case {'L', 'Ln'}
        xi = 2 * rand(m, n) - 1;
    otherwise
        error('sglib:gpc:polysys', 'Unknown polynomials system: %s', sys);
end
