function ylim_extend( ha, interval )
% YLIM_EXTEND Extend the ylimits of an axis.
%   YLIM_EXTEND( HA, INTERVAL ) extends the y axis of the handle graphics
%   object HA to contain every point also in INTERVAL. INTERVAL does not
%   have to be a real interval, but can be any set of points.
%
% Example (<a href="matlab:run_example ylim_extend">run</a>)
%    x=linspace(1,10);
%    subplot(2,1,1); plot( x, sin(x) );
%    ylim_extend( [ -1.1, 1.1 ] );
%    subplot(2,1,2); plot( x, cos(x) );
%    ylim_extend( [ -1.5 ] );
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if ~ishandle(ha)
    ylim_extend( gca, ha );
    return
end

lim=get( ha, 'ylim' );
lmin=min( [lim(:); interval(:)] );
lmax=max( [lim(:); interval(:)] );
set( ha, 'ylim', [lmin, lmax] );

%if mode