function format_info=save_format( varargin )
% SAVE_FORMAT Saves current display formatting info.
%   SAVE_FORMAT( VARARGIN ) saves the current display formatting state on
%   the stack and sets all formats given in VARARGIN. VARARGIN may also be
%   empty and format be set with direct calls to FORMAT. The old format
%   state can be restored by a call to RESTORE_FORMAT().
%
%   FORMAT_INFO=SAVE_FORMAT( VARARGIN ) returns the current formatting info
%   and does not push it on the stack. Old display formatting state can be
%   restored by a call to RESTORE_FORMAT(FORMAT_INFO).
%
% Example (<a href="matlab:run_example save_format">run</a>)
%   underline( 'Setting default format (short, loose)' );
%   save_format( '' );
%   1.1
%   underline( 'Setting compact, short g format' );
%   save_format( 'compact', 'short g' );
%   1.1
%   underline( 'Now restoring default format' );
%   restore_format();
%   1.1
%   restore_format();
%
% See also RESTORE_FORMAT, FORMAT

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

info={get(0,'Format'), get(0,'FormatSpacing') };

if nargout>0
    format_info=info;
else
    format_stack{end+1}=info;
end

for new_format=varargin
    % strread parses a space delimited string into a cell array, then we
    % pass the cell array as list to format. This makes it possible to pass
    % stuff like 'short g' as parameter to format (one of those matlab
    % insanities where both string parts have to be passed as separate
    % parameters, while constituting just one particular format.)
    c=strread( new_format{:}, '%s' );
    format( c{:} );
end
