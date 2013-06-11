function ps_bar_plot(variable, field, ps_results );% PS_BAR_PLOT Short description of ps_bar_plot.
%   PS_BAR_PLOT Long description of ps_bar_plot.
%
% Example (<a href="matlab:run_example ps_bar_plot">run</a>)
%
% See also

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

in_fields=fieldnames(variable);
yfield=in_fields{1};
xfield=in_fields{2};
bar3(cell2mat(ps_results.(field)) );
h=gca;
set(h,'XTickLabel',variable.(xfield))
xlabel(xfield,'Interpreter','none')
set(h,'YTickLabel',variable.(yfield))
ylabel(yfield,'Interpreter','none')
title(field,'Interpreter','none')
[az,el]=view(3); view(az+180,el-10);
