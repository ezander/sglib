function xi = gpc_sample(V, n)
% GPC_SAMPLE Draw samples from a GPC.
%   XI = GPC_SAMPLE(V, N) creates N rows and M columns of samples, where M
%   is the number of random variables. V contains a specification of the
%   random variables and a multiindex set (see Example). 
%
% Example 1 (<a href="matlab:run_example gpc_sample 1">run</a>)
%    I = multiindex(3,2);
%    V = {'H', I};
%    xi = gpc_sample(V, 5)
%
% Example 2 (<a href="matlab:run_example gpc_sample 2">run</a>)
%    V = {'PLp', [0, 0, 0]};
%    xi = gpc_sample(V, 3000);
%    plot(xi(1,:), xi(2,:), '.')
%    xlabel('Uniform'); ylabel('Gauss');
%
% See also GPC, GPC_EVALUATE

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
assert(length(sys)==1 || length(sys)==m)

if nargin<2
    n = 1;
end

if length(sys)==1
    xi = polysys_sample_rv(sys, m, n);
else
    check_range(length(sys), m, m, 'len(sys)==m', mfilename);
    xi = zeros(m, n);
    for j = 1:m
        xi(j,:) = polysys_sample_rv(sys(j), 1, n);
    end
end


