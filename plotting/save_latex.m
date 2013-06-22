function save_latex( texfilename, epsfilename, varargin );
% SAVE_LATEX Short description of save_latex.
%   SAVE_LATEX Long description of save_latex.
%
% Example (<a href="matlab:run_example save_latex">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[figdir,options]=get_option( options, 'figdir', '.figs' );
[psfrag_list,options]=get_option( options, 'psfrag_list', {} );
[standalone,options]=get_option( options, 'standalone', false );
[view,options]=get_option( options, 'view', false );
check_unsupported_options( options, mfilename );

% If requested also save tex file
write_tex_include( texfilename, epsfilename, psfrag_list );

if standalone
    tex_filename=write_tex_standalone( name, figdir );
    if view
        if isunix
            viewpath='/tmp/';
            texfilebase=tex_filename(1:end-4);  %#ok<NASGU>
            [path,file,ext]=fileparts( tex_filename );
            path=fullpath( path );
            cmd=strvarexpand( 'cd $viewpath$ && TEXINPUTS=$path$: latex $file$ && TEXINPUTS=$path$: dvips $file$ && gv $file$ ' );
            system( cmd );
        else
            warning( 'sglib:view_latex', 'viewing not supported on non-unix systems' );
        end
    end
end
