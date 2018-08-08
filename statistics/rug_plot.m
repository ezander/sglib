function rug_plot(x, varargin)
% RUG_PLOT Creates a rug plot of the given data.
%   RUG_PLOT(X) plots small strips at the data points specified in X. The
%   length of the strips is determined by the optional parameter SCALE,
%   which is by default 0.02. The total length is then the vertical plot
%   size times SCALE. The optional parameter DIR controls, whether the
%   strips are drawn symmetrically at 0 (DIR=0), or pointing upwards
%   (DIR=1, default) or downwards (DIR=-1).
%
% Note
%   No hold on or hold off is needed for rug_plot, as it is intended to be
%   used in addition to an existing plot.
%
% Options
%   scale: 0.02
%     Multiplication factor. The length of the fringes is "YLIM*SCALE". 
%   dir: -1, 0, {1}
%     Direction of the "fringes", correspodings to downwards, symmetric,
%     and upwards (default). 
%   color: 'r'
%     Color of the fringes. Default red ('r'). Can be a string or an rgb
%     tuple.
%
% Example (<a href="matlab:run_example rug_plot">run</a>)
%     x = randn(1, 300);
%     [xd, pd] = kernel_density(x);
%     plot(xd, pd);
%     grid on;
%     rug_plot(x, 'dir', 1, 'color', [0.9, 0.5, 0.6]);
%
% See also KERNEL_DENSITY, PLOT, EMPIRICAL_DENSITY

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
[scale, options]=get_option(options, 'scale', 0.02);
[dir, options]=get_option(options, 'dir', 1);
[color, options]=get_option(options, 'color', 'r');
check_unsupported_options(options, mfilename);

yl = ylim;
len = scale * abs(yl(2)-yl(1));
dy1 = 0.5 * len * (dir + 1);
dy2 = 0.5 * len * (dir - 1);

x=x(:);
y = zeros(size(x));
X = reshape([x,     x,     nan(size(x))]', [], 1);
Y = reshape([y+dy1, y+dy2, nan(size(x))]', [], 1);
lh=line(X, Y, 'Color', color)
lh.Color=[1,0,0,0.01];

