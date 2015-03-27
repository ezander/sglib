function multiplot_adjust_range(varargin)
% MULTIPLOT_ADJUST_RANGE Adjusts the range of all subplots of a multiplot grid.
%   MULTIPLOT_ADJUST_RANGE adjusts the ranges of all subplots of a given
%   multiplot grid. Options can be given to refine this behaviour. See the
%   OPTONS and the EXAMPLE section.
%
% Options
%   axes: string {'xyz'}
%     Specifies the axes to be adjusted (see SAME_SCALING)
%   rows: integer array {[]}
%     Subset of rows in the multiplot grid to be adjusted
%   cols: integer array {[]}
%     Subset of columns in the multiplot grid to be adjusted
%   separate: string enum {''}, 'rows', 'cols'
%     Do the adjustment separatly for each row ('row') or each column
%     ('col') for do it uniformly for all ('').
%   range: double array of length 2 {[]}
%     Use the specified range for the adjustment. [] means automatic
%     determination.
%
% Example (<a href="matlab:run_example multiplot_adjust_range">run</a>)
%
%   multiplot_init(9, [], 'ordering', 'row');
%   for i=1:9
%       x = linspace(0, i);
%       multiplot; plot(x, legendre(i,x/10)); grid on;
%   end
%   disp('Now adjusting range of rows 1 and 2...'); pause;
%   multiplot_adjust_range('rows', [1,2], 'separate', 'rows', 'axes', 'y');
%   disp('Now adjusting range of columns 1 and 3...'); pause;
%   multiplot_adjust_range('cols', [1,3], 'separate', 'cols', 'axes', 'x');
%   
% See also MULTIPLOT_INIT, MULTIPLOT, SAME_SCALING

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin,mfilename);
[axes,options]=get_option(options, 'axes', 'xyz');
[rows,options]=get_option(options, 'rows', []);
[cols,options]=get_option(options, 'cols', []);
[separate,options]=get_option(options, 'separate', '');
[range,options]=get_option(options, 'range', []);
check_unsupported_options(options);

mp_data = multiplot_data('get');

handles = mp_data.handles;
if ~isempty(rows)
    handles = handles(rows, :);
end
if ~isempty(cols)
    handles = handles(:, cols);
end

switch separate
    case {'', 'none'}
        same_scaling(handles, axes, 'range', range);
    case 'rows'
        for i=1:size(handles,1)
            same_scaling(handles(i,:), axes, 'range', range);
        end
    case 'cols'
        for j=1:size(handles,2)
            same_scaling(handles(:,j), axes, 'range', range);
        end
end
