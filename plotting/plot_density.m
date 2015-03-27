function [x,y]=plot_density(dist_or_samples, varargin)
% PLOT_DENSITY Short description of plot_density.
%   PLOT_DENSITY Long description of plot_density.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example plot_density">run</a>)
%
% See also

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

options=varargin2options(varargin);
[do_hold, options]=get_option(options,'hold',false);
% unsupported options are checked inside the plotting subfunctions

%check_type(dist_or_samples, {'cell', 'double'}, false, 'dist_or_samples', mfilename);

if do_hold
    was_hold=ishold();
    hold('all');
end

if iscell(dist_or_samples)
    [x,y]=plot_dist_density(dist_or_samples, options);
else
    [x,y]=plot_sample_density(dist_or_samples, options);
end

if do_hold && ~was_hold
    hold('off');
end
if nargout==0
    clear x y
end

function [x,y]=plot_dist_density(dist, options)
[q0,options] = get_option(options, 'q0', 0);
[q1,options] = get_option(options, 'q1', 1);
[dq,options] = get_option(options, 'dq', 0.02);
[N,options] = get_option(options, 'N', 100);
[ext,options] = get_option(options, 'ext', 0.04);
[extra_x,options] = get_option(options, 'extra_x', []);
[extra_q,options] = get_option(options, 'extra_q', []);
[type,options] = get_option(options, 'type', 'pdf');
check_unsupported_options(options, [mfilename, '/dist'])

x0 = gendist_invcdf(q0, dist);
if ~isfinite(x0)
    x0 = gendist_invcdf(q0 + dq, dist);
end
x1 = gendist_invcdf(q1, dist);
if ~isfinite(x1)
    x1 = gendist_invcdf(q1 - dq, dist);
end
x = [x0, x1];
if ext~=0
    dx = 0.5 * ext * (x1 - x0);
    x0 = x0 - dx;
    x1 = x1 + dx;
end
x = [x, linspace(x0, x1, N)];
if ~isempty(extra_q)
    x = [x, gendist_invcdf(extra_q)];
end
if ~isempty(extra_x)
    x = [x, extra_x];
end
x = unique(x);
switch(type)
    case 'pdf'
        y=gendist_pdf(x, dist);
    case 'cdf'
        y=gendist_cdf(x, dist);
    case {'both', 'pdf/cdf', 'cdf/pdf'}
        y=[gendist_pdf(x, dist); gendist_cdf(x, dist)];
end
plot(x, y);

function [xc,y]=plot_sample_density(x, options)
[type, options]=get_option(options, 'type', 'hist');
[n, options]=get_option(options, 'n', 100);
[kde_sig, options]=get_option(options, 'kde_sig', []);
[rug, options]=get_option(options, 'rug', false);
[max_rug, options]=get_option(options, 'max_rug', inf);
check_unsupported_options(options, [mfilename, '/sample']);

switch(type)
    case 'hist'
        [xc,y]=histogram(x, n);
        %error('foo');
    case 'empirical'
        error('foo');
    case {'kernel', 'kde'}
        [xc,y]=kernel_density(x, n, kde_sig);
        plot(xc,y);
    otherwise
        error('foo');
end
        
if rug
    if length(x)>max_rug
        x = x(1:max_rug);
    end
    rug_plot(x);
end

function [xc,y]=histogram(x, n)
[nbin,xc]=hist(x, n);
if n>1
    dx = (xc(2) - xc(1));
else
    dx = (max(x) - min(x));
end
y = nbin / sum(nbin) / dx;
bar(xc, y, 'BarWidth', 1, 'FaceColor', [0.9, 0.9, 0.9] );
