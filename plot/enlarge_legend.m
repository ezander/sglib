function enlarge_legend(fig_axis_h,enlarge)
% ENLARGE_LEGEND Enlarge and moves the bounding box of a legend.
%   ENLARGE_LEGEND(FIG_AXIS_H,ENLARGE) enlarges the bounding box of a
%   legend to make space for later replacement by postscript substituitons,
%   e.g. replacing the text by the 'psfrag' LaTeX package. Enlarge is an
%   array with four values [LEFT,BOTTOM,RIGHT,TOP] which specifies
%   enlargement in each direction. If a value is not given is is assumed to
%   be zero, i.e. [0.2,0.1] means enlarge in left and bottom direction by
%   0.2 and 0.1 and leave right and top as is. As in most graphics commands
%   you may leave out the FIG_AXIS_H argument in which case the current
%   axis (gca) is assumed.
%
% Example (<a href="matlab:run_example enlarge_legend">run</a>)
%   h1=subplot(2,1,1);
%   plot(x,y,x+.1,y+.1,x+.2,y+.2);
%   legend({'a','b','c'})
%   h2=subplot(2,1,2);
%   plot(x,y,x+.1,y+.1,x+.2,y+.2);
%   legend({'a','b','c'})
%   disp('Now enlarging upper legend to left and bottom. Press enter...');
%   pause;
%   enlarge_legend(h1,[0.1,0.2])
%   disp('Now enlarging lower legend to right and top. Press enter...');
%   pause;
%   enlarge_legend(h2,[0,0,0.1,0.2])
%   disp('Now moving lower legend to the left. Press enter...');
%   pause;
%   enlarge_legend([0.3,0,-0.3])
%
% See also LEGEND

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% if axis handle is given, use legend from this axis, otherwise take the
% current one and shift arguments
if ishandle(fig_axis_h)
    legend_h=legend(fig_axis_h);
else
    enlarge=fig_axis_h;
    legend_h=legend;
end

% make enlarge contain at least four element and copy to named variables
enlarge=[enlarge(:); zeros(4-numel(enlarge),1)];
left=enlarge(1);
bottom=enlarge(2);
right=enlarge(3);
top=enlarge(4);


% find axes within legend
axes_h=findall(legend_h, 'Type', 'axes');

% get position of this axis object (which is the position of the legend
% itself) and modifiy it (left,bottom,width,height)
pos=get(axes_h, 'Position');
pos=pos+[-left, -bottom, +left+right, +top+bottom];
set(axes_h, 'Position', pos);
