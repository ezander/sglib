function [x,y]=lhs_plot_grid(n)
% LHS_PLOT_GRID Plot a Latin hypercube grid.
%   LHS_PLOT_GRID(N) plots a Latin hypercube grid for 2 independent random
%   variables with N samples each. That means the (n-1) division lines in
%   each direction are plotted.
%
%   [X,Y] = LHS_PLOT_GRID(N) returns arrays for plotting the Latin
%   hypercube division lines. 
%
% Example (<a href="matlab:run_example lhs_plot_grid">run</a>)
%
% See also LHS_UNIFORM

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

x = [1:n-1; 1:n-1; nan(1,n-1)]/n;
x = x(:)';
y = repmat([0, 1, nan], 1, n-1);
if nargout==0
    old_hold_state = ishold;
    hold on;
    plot(x, y, 'k', y, x, 'k');
    if ~old_hold_state
        hold off;
    end
    clear('x', 'y');
end
