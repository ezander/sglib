function medit( filename )
% MEDIT Edit a new or existing m-file in the editor with path.
%   MEDIT( FILENAME ) opens the m-file named by FILENAME in the Matlab
%   internal editor. If FILENAME doesn't end in '.m' it is appended. This
%   function also opens the editor for not-yet-existing files if they are
%   not in the current directory (which the internal EDIT command doesn't,
%   it issues an error in this case, very annoyingly...).
%   Further, if the file doesn't exist MEDIT formats the source with a
%   predefined template.
%
% Example (<a href="matlab:run_example medit">run</a>)
%   medit private/my_priv_func
%
% See also EDIT

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


author='Elmar Zander';
institution='Institute of Scientific Computing, TU Braunschweig';

d=date;
year=d(end-3:end);


if ~strcmp( filename(end-1:end), '.m' )
    filename=[filename '.m'];
end
[pathstr,name,ext] = fileparts(filename);

is_unittest=strncmp( name, 'unittest_', 9 );
show_options=false;
show_notes=false;

if ~exist( filename, 'file' )
    fid=fopen( filename, 'w' );
    fprintf( fid, 'function %s(varargin)\n', name );
    fprintf( fid, '%% %s Short description of %s.\n', upper(name), name );
    fprintf( fid, '%%   %s Long description of %s.\n', upper(name), name );
    fprintf( fid, '%%\n' );
    if show_options
        fprintf( fid, '%%Options:\n' );
        fprintf( fid, '%%\n' );
    end
    if show_notes
        fprintf( fid, '%%Notes:\n' );
        fprintf( fid, '%%\n' );
    end
    fprintf( fid, '%% Example (<a href="matlab:run_example %s">run</a>)\n', name );
    if is_unittest
        fprintf( fid, '%%   %s\n', name );
        fprintf( fid, '%%\n' );
        fprintf( fid, '%% See also %s \n', upper(name(10:end)) );
    else
        fprintf( fid, '%%\n' );
        fprintf( fid, '%% See also\n' );
    end
    fprintf( fid, '\n' );
    fprintf( fid, '%%   %s\n', author );
    fprintf( fid, '%%   Copyright %s, %s.\n', year, institution );
    fprintf( fid, '%%   $Id$ \n' );
    fprintf( fid, '%%\n' );
    fprintf( fid, '%%   This program is free software: you can redistribute it and/or modify it\n' );
    fprintf( fid, '%%   under the terms of the GNU General Public License as published by the\n' );
    fprintf( fid, '%%   Free Software Foundation, either version 3 of the License, or (at your\n' );
    fprintf( fid, '%%   option) any later version. \n' );
    fprintf( fid, '%%   See the GNU General Public License for more details. You should have\n' );
    fprintf( fid, '%%   received a copy of the GNU General Public License along with this\n' );
    fprintf( fid, '%%   program.  If not, see <http://www.gnu.org/licenses/>.\n' );
    fclose( fid );
end

edit( filename )
