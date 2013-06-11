function makesavepath( file )
% MAKESAVEPATH Making necessary subdirs for saving a file.
%   MAKESAVEPATH( FILE ) makes all necessary subdirs that are needed to
%   create the file FILE.
%
% Example (<a href="matlab:run_example msave">run</a>)
%   % the following should create the directory 'foo'
%   makesavepath( fullfile( 'foo', 'bar.mat' ) )
% 
% See also MKDIR, SAVE

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

pathstr = fileparts(file);
while ~isempty(pathstr) && ~exist(pathstr, 'dir' )
    [status,message,messageid]=mkdir(pathstr);
    if ~status
        fprintf( 'Could not make directory %s: %s (%s)\n', pathstr, message, messageid ); 
        fprintf( 'If you want, you can do something about it now...\n' ); 
        fprintf( 'I.e. create the directory and press F5 to continue or abort the program.\n' ); 
        keyboard;
    end
end
