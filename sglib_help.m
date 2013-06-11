function sglib_help
% SGLIB_HELP Show SGLIB help overview.
%
% Example (<a href="matlab:run_example sglib_help">run</a>)
%   sglib_help
%
% See also SGLIB_STARTUP

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


% before running the setup should have been performed at least partly
sglib_check_setup;

% get sglib base path from appdata
path=sglib_get_appdata( 'basepath' );

underline('Help topics');
helplink( path, 'General information on SGLIB', 'doc' );
helplink( path, 'Main SGLIB functions', '.' );
helplink( path, 'Utility functions', 'util' );
helplink( path, 'Plotting support functions', 'plot' );
helplink( path, 'Unit testing', 'munit' );
helplink( path, 'Some simple FEM routines', 'simplefem' );
helplink( path, 'Demonstration scripts', 'demo' );


function helplink( path, descr, dir )
file=fullfile( path, dir, 'Contents.m');
% fprintf( '%s: <a href="matlab:help %s">Contents</a>\n', descr, file );
fprintf( ' * <a href="matlab:help %s">%s</a>\n', file, descr );
