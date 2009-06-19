function sglib_help
% SGLIB_HELP Show SGLIB help overview.
%
% Example (<a href="matlab:run_example sglib_help">run</a>)
%   sglib_help
%
% See also SGLIB_STARTUP

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

path=pwd;
underline('Help topics');
helplink( path, 'General information on SGLib', 'doc' );
helplink( path, 'Main SGLib functions', '.' );
helplink( path, 'Utility function', 'util' );
helplink( path, 'Plotting support function', 'plot' );
helplink( path, 'Unit testing', 'munit' );
helplink( path, 'Some simple FEM routines', 'simplefem' );
helplink( path, 'Some simple FEM Demonstration scripts', 'demo' );


function helplink( path, descr, dir )
file=[path '/' dir '/Contents.m'];
fprintf( '%s: <a href="matlab:help %s">Contents</a>\n', descr, file );
