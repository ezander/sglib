function save_figure( handle, name, varargin )
% SAVE_FIGURE Short description of save_figure.
%   SAVE_FIGURE Long description of save_figure.
%
% Example (<a href="matlab:run_example save_figure">run</a>)
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


global sglib_figdir

options=varargin2options(varargin);
[eps_params, options]=get_option(options,'eps_params',{});
[pdf_params, options]=get_option(options,'pdf_params',{});
[png_params, options]=get_option(options,'png_params',{});
[png2eps_params, options]=get_option(options,'png2eps_params',{});
[latex_params, options]=get_option(options,'latex_params',{});
[figdir, options]=get_option(options,'figdir',sglib_figdir);
[type, options]=get_option(options,'type','vector');
[use_psfrag, options]=get_option(options,'use_psfrag',false);
[afterreparent, options]=get_option(options,'afterreparent',[]);
[debug_fig, options]=get_option(options,'debug_fig',false);
[fontsize, options]=get_option(options,'fontsize',24);
[text_interpreter, options]=get_option(options,'text_interpreter','none');
check_unsupported_options(options,mfilename);

if isempty( handle )
    handle=gca;
end
if ~ishandle( handle )
    error( 'sglib:save_figure', 'First argument  must be a handle' );
end
if isempty(figdir)
    warning( 'sglig:save_figure', 'figdir not set set. Set explicitly or via global variable sglib_figdir' );
    sglib_figdir=fullfile( getenv('HOME'), 'projects', 'docs', 'stochastics', 'thesis', 'figures');
    figdir=sglib_figdir;
end

common_params={'figdir', figdir};

if strcmp( get( handle, 'type' ), 'axes' )
    [newaxis,newfig]=reparent_axes( handle ); %#ok<ASGLU>
    handle=newfig;
    if debug_fig
        set(newfig,'visible', 'on');
    end
else
    newfig=[];
end
check_handle( handle, 'figure' );
set( handle, 'renderer', 'painters' );

if ~isempty(afterreparent)
    funcall( afterreparent, newaxis, newfig );
end

if use_psfrag
    psfrag_list=psfrag_format( handle );
    latex_params=[latex_params, {'psfrag_list', psfrag_list}];
else
    latex_format( handle, fontsize, text_interpreter );
    %disp( 'latex_format figure' );
end

pngfilename=make_filename( name, figdir, 'png' );
epsfilename=make_filename( name, figdir, 'eps' );
pdffilename=make_filename( name, figdir, 'pdf' );
texfilename=make_filename( name, figdir, 'tex' );

png_params=[common_params, png_params];
eps_params=[common_params, eps_params];
pdf_params=[common_params, pdf_params];
latex_params=[common_params, latex_params];

% save the png anyway
save_png( handle, name, png_params{:} );

switch type
    case 'raster'
        % for raster type we need only convert to eps, since pdflatex can
        % use the png file
        convert_png_eps( pngfilename, png2eps_params{:} );
    case 'vector'
        % for vector graphics also the pdf file needs to be created, so
        % that pdflatex does not use the png (however, the order for
        % graphicx needs to be set correctly)
        save_eps( handle, name, eps_params{:} );
end
convert_eps_pdf( epsfilename );
save_latex( texfilename, epsfilename, latex_params{:} );

if ~debug_fig
    close( newfig );
end


function latex_format( handle, fontsize, text_interpreter )
global dvi_spacing
dvi_spacing=130000;

h_text  = findall(handle, 'type', 'text');
h_axes  = findall(handle, 'type', 'axes');
h_font   = [h_text; h_axes];

%set( h_text, 'interpreter', 'latex' );
set( h_text, 'interpreter', text_interpreter );
set( h_font, 'fontunits', 'points' );
set( h_font, 'fontsize', fontsize );
%set( h_font, 'fontname', 'times new roman' );
%set( h_font, 'fontname', 'bookman' );
set( h_font, 'fontname', 'new century schoolbook' );
%set( h_font, 'fontname', 'new century schoolbook' );
set( h_font, 'fontweight', 'normal' );


%set( h_text, 'edgecolor', 'red' );

