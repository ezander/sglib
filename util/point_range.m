function ti=point_range( t, varargin )
% POINT_RANGE Create points for plotting functions with jumps.
%   TI=POINT_RANGE( T, OPTIONS) create a vector of nodes for plotting from
%   the given node vector. TI includes 100 points from MIN(T) to MAX(T),
%   plus each node in T the node itself and two nodes which are a very
%   small delta to both sides. This is good for plotting non-continuous
%   functions as then the slopes become truly vertical without unduly
%   raising the total number of points. If LIMIT is true (the default) the
%   range of TI is limited to that of T, otherwise it's T plus/minus the
%   same delta, so that jumps at the borders can also be seen.
%
% Options:
%   ext: {0} 
%     Extend the range dt=max(t)-min(t) by a factor of ext*dt to both
%     sides.
%   limit: 
%     Limit the range to the rang of T. Default is true if EXT is zero, and
%     false otherwise.
%   N: {100}
%     Number of linearly spaced points to add.
%
% Example (<a href="matlab:run_example point_range">run</a>)
%   beta1={'beta', {0.1, 0.2}, 0, 1}; % jumps at 0 and 1
%   beta2={'beta', {1, 1}, 0.3, 0.2}; % jumps at 0.7 and 0.9
%   func = @(x)(gendist_pdf(x, beta1{:}) + gendist_pdf(x, beta2{:}));
%
%   xl = linspace(0, 1, 100);
%   subplot(2,1,1)
%   plot(xl, func(xl))
%   title('Points from linspace')
%
%   xp = point_range([0, 1, 0.7, 0.9], 'ext', 0.01);
%   subplot(2,1,2)
%   plot(xp, func(xp))
%   ylim([0,20])
%   title('Points from point\_range')
%
% See also LINSPACE, SQRSPACE, LOGSPACE

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

options=varargin2options( varargin );
[ext,options]=get_option( options, 'ext', 0 );
[limit,options]=get_option( options, 'limit', (ext==0) );
[N,options]=get_option( options, 'N', 100 );

t1=min(t);
t2=max(t);
dt=t2-t1;

ti=linspace(t1-ext*dt, t2+ext*dt, N);

del=100*eps*dt;
ti=unique( [t-del, t, t+del, ti] );

if limit
    ti(ti<min(t))=[];
    ti(ti>max(t))=[];
end
