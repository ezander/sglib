function [x,w]=clenshaw_curtis_nested(n)
% CLENSHAW_CURTIS_NESTED Compute the nested Clenshaw-Curtis rule.
%   [X,W]=CLENSHAW_CURTIS_NESTED(N) computes the Clenshaw-Curtis rule of
%   order M=2^(N-1)+1. This is mainly for sparse grid integration where
%   nested rules are advantageous.
%
% Example (<a href="matlab:run_example clenshaw_curtis_nested">run</a>)
%   clf; hold all
%   for i = 1:5
%     [x, w] = clenshaw_curtis_nested(i);
%     plot(x, i*ones(size(x)), 'x');
%   end
%   xlim([-1.3, 1.3]); ylim([0.5, 5.5])
%
% See also SMOLYAK_GRID, INTEGRATE_ND, CLENSHAW_CURTIS_RULE

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

m = 2^(n-1)+1;
[x,w]=clenshaw_curtis_rule(m);
