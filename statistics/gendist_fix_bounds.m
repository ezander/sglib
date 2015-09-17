function dist_new=gendist_fix_bounds(dist, min, max, varargin)
% GENDIST_FIX_BOUNDS Fixes the bounds for distributions on bounded intervals.
%   DIST_NEW=GENDIST_FIX_BOUNDS(DIST, MIN, MAX) computes from the
%   distribution DIST a new shifted and scaled distribution DIST_NEW such
%   that the new distribution is bounded by [MIN, MAX]. 
%
%   If DIST is an unbounded distribution the options 'q0' and or 'q1' can
%   be set. Then the Q0 quantile of the new distribution will be MIN and
%   the Q1 quantile will be MAX (see Example 2). If these options are not
%   set, they default to 0 and 1, which means the bounds of the
%   distribution.
%
% Example 1 (<a href="matlab:run_example gendist_fix_bounds 1">run</a>)
%   % Bound a Beta distribution between 0.5 and 3
%   dist = gendist_create('beta', {1.2, 1.4});
%   dist = gendist_fix_bounds(dist, 0.5, 3);
%   xi = gendist_sample(100000, dist);
%   [min(xi), max(xi)]
%   hist(xi, 100);
%
% Example 2 (<a href="matlab:run_example gendist_fix_bounds 2">run</a>)
%   % Bound a normal distribution such that 90% are between 2 and 4
%   dist = gendist_create('normal');
%   dist = gendist_fix_bounds(dist, 2, 4, 'q0', 0.05, 'q1', 0.95);
%   x = linspace(0, 6);
%   plot(x, gendist_pdf(x, dist), x, gendist_cdf(x, dist), ...
%        x, repmat(0.05, size(x)), x, repmat(0.95, size(x)));
%   grid on;
%
% See also GENDIST_CREATE, GENDIST_PDF, GENDIST_FIX_MOMENTS

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

if isa(dist, 'Distribution')
    dist_new = dist.fix_bounds(min, max, varargin{:});
    return
end

options=varargin2options(varargin);
[q0,options]=get_option(options,'q0',0);
[q1,options]=get_option(options,'q1',1);
check_unsupported_options(options,mfilename);

% check bounds for the lower and upper quantiles (q0 and q1)
check_range(q0, 0, 1, 'q0', mfilename);
check_range(q1, q0, 1, 'q1', mfilename);

% get the x values corresponding to the quantiles
old_min=gendist_invcdf( q0, dist );
old_max=gendist_invcdf( q1, dist );

% check that the min and max are finite (i.e. either it was a bounded
% distribution or quantiles are different from 0 or 1)
if ~isfinite(old_min)
    error('sglib:statistics', 'Lower quantile (q0) gives infinity (unbounded distribution?)');
end
if ~isfinite(old_max)
    error('sglib:statistics', 'Upper quantile (q1) gives infinity (unbounded distribution?)');
end

% Get the new scale and shift factors (just a linear mapping, only the
% shift is a bit tricky since the mean needs to be taken into account. BTW:
% it doesn't make a difference whether the min or the max is used for the
% shift calculation).
[distname, params, old_shift, old_scale, mean] = gendist_get_args(dist);
mean = dist{5};
scale = (max-min) / (old_max-old_min);
shift = min - ((old_min-mean-old_shift)*scale + mean+old_shift);

% Create the new distribution object
dist_new = dist;
dist_new{3} = dist{3} + shift;
dist_new{4} = dist{4} * scale;
