function str=write_tex_tabular(filename, table, varargin)
% WRITE_TEX_TABULAR Short description of write_tex_tabular.
%   WRITE_TEX_TABULAR Long description of write_tex_tabular.
%
% Example (<a href="matlab:run_example write_tex_tabular">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[row_values,options]=get_option(options,'row_values', [] );
[col_values,options]=get_option(options,'col_values', [] );
[hline,options]=get_option(options,'hline', true );
[tabular,options]=get_option(options,'tabular', true );
[col_format,options]=get_option(options,'col_format', '' );
[row_format,options]=get_option(options,'row_format', '' );
[table_format,options]=get_option(options,'table_format', '' );
[position,options]=get_option(options,'position', '' );
check_unsupported_options(options,mfilename);

table=to_cell(table,false);
row_values=to_cell(row_values,true);
col_values=to_cell(col_values,true);

[M,N]=size(table);
if ~isempty(row_values) && length(row_values)~=M
    error('write_tex_tabular:wrong_input', 'number of row_values %d does not match number of table rows (%d)', length(row_values), M );
end
if ~isempty(col_values) && length(col_values)~=N
    error('write_tex_tabular:wrong_input', 'number of col_values %d does not match number of table columns (%d)', length(col_values), N );
end

if isempty(filename)
    fid=-1;
    var_printf;
else
    makesavepath(filename);
    fid=fopen(filename,'w');
end

col_mod=double(~isempty(row_values));

justification='';
if ~isempty(row_values)
    justification=[justification, 'r'];
end
for j=1:N
    justification=[justification, 'r'];
end
tex_print_line( fid, ['\begin{tabular}[', position, ']{', justification, '}'], tabular );



if ~isempty(col_values)
    for j=1:N
        tex_print_tab_value( fid, j+col_mod, col_values{j}, col_format );
    end
    tex_print_line( fid, '\\' );
    tex_print_line( fid, '\hline', hline );
end
for i=1:M
    if ~isempty(row_values)
        tex_print_tab_value( fid, 1, row_values{i}, row_format );
    end
    for j=1:N
        tex_print_tab_value( fid, j+col_mod, table{i,j}, table_format );
    end
    tex_print_line( fid, '\\' );
end

tex_print_line( fid, '\end{tabular}', tabular );

if fid~=-1
    fclose(fid);
else
    str=var_printf;
end

function vals=to_cell(vals,vectorize)
if isempty(vals)
    return;
elseif ~iscell(vals)
    if isnumeric(vals)
        vals=num2cell(vals);
    else
        error('write_tex_tabular:wrong_input', 'Don''t know how to convert to cell array: %s', class(x) );
    end
end
if vectorize
    vals=vals(:);
end

function tex_print_line( fid, tex_string, condition )
if nargin<=2 || condition
    var_printf( fid, '%s\n', tex_string );
end

function tex_print_tab_value( fid, col, value, format )
if col>1
    var_printf( fid, '&' );
end
if nargin<4 || isempty(format)
    if isnumeric(value)
        format='%g';
    elseif ischar(value)
        format='%s';
    else
        error('write_tex_tabular:wrong_input', 'Don''t know which format to use for class: %s', class(x) );
    end
end
var_printf( fid, format, value );

function str=var_printf( fid, varargin )
persistent stracc;
if nargin==0
    str=stracc;
    stracc='';
elseif fid>=0
    fprintf( fid, varargin{:} );
else
    stracc=[stracc, sprintf( varargin{:} )];
end
