function clear_funcall_cache(varargin)
% CLEAR_FUNCALL_CACHE Short description of clear_funcall_cache.
%   CLEAR_FUNCALL_CACHE Long description of clear_funcall_cache.
%
% Example (<a href="matlab:run_example clear_funcall_cache">run</a>)
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

options=varargin2options( varargin );
[pattern,options]=get_option( options, 'pattern', '' );
[path,options]=get_option( options, 'path', cache_file_base() );
[verbosity,options]=get_option( options, 'verbosity', 0 );
check_unsupported_options( options, mfilename );

if any( pattern==filesep )
    % dir specs in pattern does not work smoothly with the dir function
    error( 'sglib:clear_funcall_cache', 'Pattern may not contain a directory specification.' );
end

spec=fullfile( path, [pattern, '*.mat'] );
files=dir( spec ); % 'ls' include the path in the return values (in contrast to 'dir')
if verbosity>0
    disp( 'Removing cache files: ' );
end

for i=1:length(files)
    file=fullfile( path, files(i).name );
    if verbosity>0
        disp( file );
    end
    delete( file );
end
