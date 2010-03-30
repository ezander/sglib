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
    save_eps( gcf, name, varargin{:} );
    return
end


options=varargin2options( varargin );
[figdir,options]=get_option( options, 'dir', '.figs' );
%[psfrag,options]=get_option( options, 'psfrag', true );
[standalonetex,options]=get_option( options, 'standalonetex', true );
[graphicstype,options]=get_option( options, 'graphicstype', 'eps' );
%[notitle,options]=get_option( options, 'notitle', true );
check_unsupported_options( options, mfilename );

makecopy=false;
if makecopy
    if strcmp( get(handle,'type'), 'axes' )
        h_workfig=figure('Visible','on');
        h_workaxis=copyobj( handle, h_workfig );
        legend_h=legend( handle );
        copyobj( legend_h, h_workfig );
    else
        h_workfig=copyobj( handle, 0 );
        h_workaxis=findobj( h_workfig, '-depth', 1, 'type', axes );
    end
else
    h_workaxis=handle;
    h_workfig=get(h_workaxis, 'parent' );
end

set( h_workfig, 'renderer', 'painters' );
psfrag_list=psfrag_format( h_workaxis );
save_eps( h_workfig, [name '-psf']  );

if makecopy
    close( h_workfig );
end

% If requested also save tex file
texview=true;
write_tex_include( name, figdir, graphicstype, psfrag_list );
if standalonetex
    tex_filename=write_tex_standalone( name, figdir );
    if texview
        viewpath='/tmp/';
        texfilebase=tex_filename(1:end-4);  %#ok<NASGU>
        [path,file,ext]=fileparts( tex_filename );
        fullpath=fullfile( pwd, path );
        cmd=strvarexpand( 'cd $viewpath$ && TEXINPUTS=$fullpath$: latex $file$ && TEXINPUTS=$fullpath$: dvips $file$ && gv $file$ ' );
        system( cmd );
    end
end
