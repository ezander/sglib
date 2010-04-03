function save_latex( handle, name, varargin )
% SAVE_LATEX Short description of save_latex.
%   SAVE_LATEX Long description of save_latex.
%
% Example (<a href="matlab:run_example save_latex">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if ~ishandle( handle )
    save_latex( gca, handle, varargin{:} );
    return
end


options=varargin2options( varargin );
[figdir,options]=get_option( options, 'figdir', '.figs' );
%[psfrag,options]=get_option( options, 'psfrag', true );
[standalonetex,options]=get_option( options, 'standalonetex', true );
[graphicstype,options]=get_option( options, 'graphicstype', 'eps' );
[view,options]=get_option( options, 'view', false );
check_unsupported_options( options, mfilename );

h_workaxis=handle;
h_workfig=get( handle, 'parent' );

set( h_workfig, 'renderer', 'painters' );
psfrag_list=psfrag_format( h_workaxis );
save_eps( h_workfig, [name '-psf'], 'figdir', figdir  );


% If requested also save tex file
write_tex_include( name, figdir, graphicstype, psfrag_list );
if standalonetex
    tex_filename=write_tex_standalone( name, figdir );
    if view
        viewpath='/tmp/';
        texfilebase=tex_filename(1:end-4);  %#ok<NASGU>
        [path,file,ext]=fileparts( tex_filename );
        path=fullpath( path );
        cmd=strvarexpand( 'cd $viewpath$ && TEXINPUTS=$path$: latex $file$ && TEXINPUTS=$path$: dvips $file$ && gv $file$ ' );
        system( cmd );
    end
end
