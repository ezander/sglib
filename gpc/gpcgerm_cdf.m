function p=gpcgerm_cdf(V, xi)
% GPCGERM_CDF Computes the joint CDF of the GPC germ.
%   P=GPCGERM_CDF(V, XI) computes the joint probability density function of
%   the GPC germ specified in V at the points given in XI. 
%
% Example (<a href="matlab:run_example gpcgerm_cdf">run</a>)
%   [X,Y] = meshgrid(linspace(-3,3,40));
%   V = gpcbasis_create('hh');
%   Z = reshape(gpcgerm_cdf(V, [X(:), Y(:)]'), size(X));
%   subplot(1,2,1); surf(X, Y, Z);
%   V = gpcbasis_create('pu');
%   Z = reshape(gpcgerm_cdf(V, [X(:), Y(:)]'), size(X));
%   subplot(1,2,2); surf(X, Y, Z);
%
% See also GPC, GPCGERM_PDF

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
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

check_match(I, xi, false, 'I', 'xi', mfilename);

if length(sys)==1
    p = prod(polysys_cdf(sys, xi), 1);
else
    check_range(length(sys), m, m, 'len(sys)==m', mfilename);
    p = ones(1, size(xi, 2));
    for j = 1:m
        p = p.* polysys_cdf(sys(j), xi(j, :));
    end
end

function y=polysys_cdf(sys, x)
dist = polysys_dist(sys);
y = gendist_cdf(x, dist);
