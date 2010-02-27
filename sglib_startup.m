% SGLIB_STARTUP Called automatically by Matlab at startup.
%   STARTUP gets automatically called by Matlab if it was started from THIS
%   directory (i.e. the sglib home directory). STARTUP just delegates the
%   work SGLIB_STARTUP, so that SGLIB_STARTUP can be called from anywhere
%   else without interfering with any other startup script that might be on
%   the path.
%
% Note: This mfile is intentionally a script and no function, so it can be
%   run via RUN. E.g. run('../sglib_startup');
%
% Example (<a href="matlab:run_example sglib_startup">run</a>)
%   sglib_startup
%
% See also STARTUP, RUN, SGLIB_ADDPATH

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% initialize appdata structure
appdata=struct();

% get the sglib home path
basepath=fileparts( mfilename('fullpath') );
addpath( basepath );

%
is_octave=exist('octave_config_info', 'builtin');
inc_experimental=false;
sglib_addpath( basepath, false, inc_experimental, is_octave );

% put stuff in appdata
appdata.basepath=basepath;
appdata.settings_file=[basepath '/sglib.settings' ];
sglib_set_appdata( appdata );

% do some init stuff depending on matlab/octave version
if isoctave
else
    %isversion
end

% try to load settings from file
appdata.settings=sglib_settings( 'load' );

% show greeting if user wants that
if appdata.settings.show_greeting
    fprintf( '\nSGLIB v0.9\n' );
    fprintf( 'Type SGLIB_HELP to get <a href="matlab:sglib_help">help</a>.\n' );
    fprintf( 'Type SGLIB_SETTINGS for changing the <a href="matlab:sglib_settings">settings</a>.\n\n' );
end

% init contrib if it exists
if exist( 'init_contrib', 'file' )
    init_contrib;
end
