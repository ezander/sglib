function multiplot_save_all(filename_pattern, rownames, colnames)
% MULTIPLOT_SAVE_ALL Save all multiplot axes separately.
%   MULTIPLOT_SAVE_ALL(FILENAME_PATTERN, ROWNAMES, COLNAMES) saves all axes
%   to PNGs where the filename is generated from the pattern and each $row$
%   is replaced by the ROWNAMES{I} and $col$ by COLNAMES{J}. ROWNAMES and
%   COLNAMES have to be cell arrays of strings or values convertible to
%   strings containing the row and column names.
%
% Example (<a href="matlab:run_example multiplot_save_all">run</a>)
%   multiplot_save_all(['figures/image_$row$_$col$', ...
%      {'a', 'b', 'c'}, {1, 5, 20});
%   % Creates files: figures/image_a_1, figures/image_a_5 and so on
%
% See also

%   Elmar Zander
%   Copyright 2016, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

mp_data = multiplot_data('get');
if ~isfield(mp_data, 'handles')
    error('sglib:multiplot', 'MULTIPLOT_INIT must be called before calling MULTIPLOT');
end

if isnumeric(rownames)
    rownames = num2cell(rownames);
end
if isnumeric(colnames)
    colnames = num2cell(colnames);
end

handles = mp_data.handles;
handles = mp_data.fh;
for i = 1:size(handles,1)
    for j=1:size(handles,2)
        row = rownames{i};
        col = colnames{j};
        filename = strvarexpand(filename_pattern);
        save_png( handles(i,j), filename, 'figdir', '.');
    end
end
