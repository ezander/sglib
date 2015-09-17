function medit( filename, prepend )
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
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


settings=sglib_get_appdata( 'settings' );
author=get_option( settings, 'medit_author', '<author>' );
institution=get_option( settings, 'medit_institution', '<institution>' );
show_options=get_option( settings, 'medit_options_and_notes', false );
show_notes=show_options;

d=date;
year=d(end-3:end);


if ~strcmp( filename(end-1:end), '.m' )
    filename=[filename '.m'];
end
[pathstr,name,ext] = fileparts(filename); %#ok

is_unittest=strncmp( name, 'unittest_', 9 );
if is_unittest
    show_options=false;
    show_notes=false;
    testfunction=name(10:end);
end

prev_contents=[];
writetofile=false;
if ~exist( filename, 'file' )
    % if file doesn't yet exist we'll write to it
    writetofile=true;
else
    if nargin>1 && all(prepend(:))
        % if file exists and user wants to prepend save contents of file
        writetofile=true;
        prev_contents=readfile( filename );
    else
        % if file exists but is empty we also write to the file
        fid=fopen( filename, 'r' );
        if fid~=-1
            if fseek( fid, 0, 'eof' )==0 && ftell( fid )==0
                writetofile=true;
            end
            fclose(fid);
        end
    end
    if writetofile
        % the following three line give the full file path of the file 
        % the would be opened (note: fopen with 'r' looks for the file in
        % the path, while fopen with 'w' open the file with exactly the
        % path specified)
        fid=fopen( filename, 'r' );
        filename=fopen(fid);
        fclose(fid);
    end
end

if writetofile
    % If the file already begin with 'function ...' we keep that line
    func = sprintf( '%s(varargin)', name );
    ind=strfind(prev_contents, sprintf('\n'));
    if ~isempty(ind) && strncmp(prev_contents, 'function ', 9)
        ind=ind(1);
        func = prev_contents(10:ind-1);
        prev_contents = prev_contents(ind+1:end);
    end
    
    % Open file and write the help template stuff
    fid=fopen( filename, 'w' );
    if ~is_unittest
        fprintf( fid, 'function %s\n', func );
        fprintf( fid, '%% %s Short description of %s.\n', upper(name), name );
        fprintf( fid, '%%   %s Long description of %s.\n', upper(func), name );
    else
        fprintf( fid, 'function %s\n', func );
        fprintf( fid, '%% %s Test the %s function.\n', upper(name), upper(testfunction) );
    end
    
    fprintf( fid, '%%\n' );
    if show_options
        fprintf( fid, '%% Options\n' );
        fprintf( fid, '%%\n' );
    end
    if show_notes
        fprintf( fid, '%% References\n' );
        fprintf( fid, '%%\n' );
        fprintf( fid, '%% Notes\n' );
        fprintf( fid, '%%\n' );
    end
    fprintf( fid, '%% Example (<a href="matlab:run_example %s">run</a>)\n', name );
    if ~is_unittest
        fprintf( fid, '%%\n' );
        fprintf( fid, '%% See also\n' );
    else
        fprintf( fid, '%%   %s\n', name );
        fprintf( fid, '%%\n' );
        fprintf( fid, '%% See also %s, MUNIT_RUN_TESTSUITE \n', upper(testfunction) );
    end
    fprintf( fid, '\n' );
    fprintf( fid, '%%   %s\n', author );
    fprintf( fid, '%%   Copyright %s, %s\n', year, institution );
    fprintf( fid, '%%\n' );
    fprintf( fid, '%%   This program is free software: you can redistribute it and/or modify it\n' );
    fprintf( fid, '%%   under the terms of the GNU General Public License as published by the\n' );
    fprintf( fid, '%%   Free Software Foundation, either version 3 of the License, or (at your\n' );
    fprintf( fid, '%%   option) any later version. \n' );
    fprintf( fid, '%%   See the GNU General Public License for more details. You should have\n' );
    fprintf( fid, '%%   received a copy of the GNU General Public License along with this\n' );
    fprintf( fid, '%%   program.  If not, see <http://www.gnu.org/licenses/>.\n' );
    if is_unittest
        fprintf( fid, '\n' );
        fprintf( fid, 'munit_set_function( ''%s'' );\n', testfunction );
    end
    fprintf( fid, '\n' );
    if ~isempty( prev_contents )
        fprintf( fid, '%s', prev_contents );
    end
        
    fclose( fid );
end

try
    err = false;
    oldpath=addpath(fullfile(matlabroot, 'toolbox', 'matlab', 'codetools'), '-begin');
    edit(filename);
catch %#ok<CTCH>
    err = true;
end
matlabpath(oldpath)
if err
    rethrow(lasterror); %#ok<LERR>
end



function S=readfile( filename )
fid=fopen(filename,'r');
S=[];
while true
    line=fgets(fid);
    if line==-1; break; end
    S=[S line]; %#ok<AGROW>
end
fclose(fid);
