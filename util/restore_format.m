function restore_format(format_info)
% RESTORE_FORMAT Restores display formatting info.
%   RESTORE_FORMAT() restores the display formatting that was saved by
%   a call to SAVE_FORMAT without output arguments.
%
%   RESTORE_FORMAT(FORMAT_INFO) restores the display formatting that was
%   returned by a call to SAVE_FORMAT with output arguments.
%
% Example (<a href="matlab:run_example restore_format">run</a>)
%   underline( 'Setting default format (short, loose)' );
%   info1=save_format( '' );
%   1.1
%   underline( 'Setting compact, long format' );
%   info2=save_format( 'compact', 'long' );
%   1.1
%   underline( 'Now restoring default format' );
%   restore_format(info2);
%   1.1
%   restore_format(info1);
%
% See also SAVE_FORMAT, FORMAT

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

global format_stack
if isempty( format_stack )
    format_stack=cell(1,0);
end

if nargin==0
    if size(format_stack)<1
        error( 'restore_format:empty_stack', 'Tried to pop an empty format stack' );
    end
    format_info=format_stack{end};
end
set(0,'Format',format_info{1});
set(0,'FormatSpacing',format_info{2});
format_stack=format_stack(1:end-1);
