function msave( file, varargin )
% MSAVE Save variables to a file making subdirs as appropriate.
%   MSAVE( FILE, VARARGIN ) has exactly the same options and meaning as the
%   builtin SAVE command, however if FILE contains a directory
%   specification and the directory does not exist MSAVE first tries to
%   create this directory.
%
% Example (<a href="matlab:run_example msave">run</a>)
%   msave( 'foo/bar.mat', '-v6' )
% 
% See also SAVE

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

pathstr = fileparts(file);
while ~exist(pathstr, 'dir' )
    [status,message,messageid]=mkdir(pathstr);
    if ~status
        fprintf( 'Could not make directory %s: %s (%s)\n', pathstr, message, messageid ); 
        fprintf( 'If you want, you can do something about it now...\n' ); 
        fprintf( 'I.e. create the directory and press F5 to continue or abort the program.\n' ); 
        keyboard;
    end
end
save( file, varargin{:} )
