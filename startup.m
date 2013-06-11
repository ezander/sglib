function startup
% STARTUP Called automatically by Matlab at startup.
%   STARTUP gets automatically called by Matlab if it was started from THIS
%   directory (i.e. the sglib home directory). STARTUP just delegates the
%   work SGLIB_STARTUP, so that SGLIB_STARTUP can be called from anywhere
%   else without interfering with any other startup script that might be on
%   the path.
%   
%   For more information on startup files click <a href="matlab:doc startup">here</a>.
%
% Note: if the user (i.e. you) has a starup.m file in his or her home
%   directory, this startup file is also executed after the sglib_startup
%   file has executed.
% 
%
% Example (<a href="matlab:run_example startup">run</a>)
%   startup
%
% See also SGLIB_STARTUP

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% We do the real startup in a file with a special name (SGLIB_STARTUP) so
% the user can run it individually without any startup on the path
% interfering with this one
sglib_startup;

% If exists run user startup.m file. Do after sglib startup since otherwise
% user pathdefs might be resetted.
userdir=getenv('HOME');

if ~strcmp(userdir, '') && ~strcmp(userdir, pwd) && exist( fullfile( userdir, 'startup.m'), 'file')
    %fprintf('Running user startup.m ...\n')
    run(fullfile( userdir, 'startup.m') );
end
