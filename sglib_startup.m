% SGLIB_STARTUP Called automatically by Matlab at startup.
%   STARTUP gets automatically called by Matlab if it was started from THIS
%   directory (i.e. the sglib home directory). STARTUP just delegates the
%   work SGLIB_STARTUP, so that SGLIB_STARTUP can be called from anywhere
%   else without interfering with any other startup script that might be on
%   the path.
%
% Note: This mfile is intentionally a script and no function, so it can be
%   run via RUN. E.g. run( fullfile( '..', 'sglib_startup') );
%
% Example (<a href="matlab:run_example sglib_startup">run</a>)
%   sglib_startup
%
% See also STARTUP, RUN, SGLIB_ADDPATH

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

% Probably it is not nice turnig this off generally, however it is very
% annoying to warning after warning just because one of sglib's functions
% has the same name as a function in Simulink (whoever cares for that).
warning( 'off', 'MATLAB:dispatcher:nameConflict' );


% initialize appdata structure
appdata=struct();

% get the sglib home path
basepath=fileparts( mfilename('fullpath') );
addpath( basepath );

%
is_octave=exist('octave_config_info', 'builtin');
sglib_addpath( basepath, false, is_octave );

% locate the settings file (first in user's home dir, than in sglib path)
appdata.basepath=basepath;
homedir = getenv('HOME');
settings_basename = 'sglib.settings';

% The algorithm is like follows: if there is alread a settings file in the
% sglib base directory that is used, if not, but there is one in the users
% home directory that one is used, is there is still none one will be
% created in the sglib base directory
settings_file = fullfile(basepath, settings_basename);
if ~exist(settings_file, 'file')
    settings_file = fullfile(homedir, settings_basename);
    if ~exist(settings_file, 'file')
        settings_file = fullfile(basepath, settings_basename);
    end
end
appdata.settings_file=settings_file;


% put stuff in appdata
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
    [versionstr, msgs] = sglib_version('as_string', true);
    fprintf( '\nSGLIB v%s\n', versionstr );
    for msg = msgs
        fprintf( '%s\n', msg{1} );
    end
    fprintf( '\nSettings file: %s\n', appdata.settings_file );
    fprintf( '\nChecking toolboxes:\n' );
end

% disable unused toolboxes
% disable_toolboxes

% init contrib if it exists
if exist( 'init_contrib', 'file' )
    init_contrib;
end


if appdata.settings.show_greeting
    fprintf( '\nType SGLIB_HELP to get <a href="matlab:sglib_help">help</a>.\n' );
    fprintf( 'Type SGLIB_SETTINGS for changing the <a href="matlab:sglib_settings">settings</a>.\n' );
    fprintf( 'Type SGLIB_TESTSUITE to run the <a href="matlab:sglib_testsuite">unit tests</a>.\n\n' );
end
