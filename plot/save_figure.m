function save_figure( handle, name, type, varargin )
% SAVE_FIGURE Short description of save_figure.
%   SAVE_FIGURE Long description of save_figure.
%
% Example (<a href="matlab:run_example save_figure">run</a>)
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


global sglib_figdir

options=varargin2options(varargin);
[eps_params, options]=get_option(options,'eps_params',{});
[png_params, options]=get_option(options,'png_params',{});
[png2eps_params, options]=get_option(options,'png2eps_params',{});
[latex_params, options]=get_option(options,'latex_params',{});
[figdir, options]=get_option(options,'figdir',sglib_figdir);
[use_psfrag, options]=get_option(options,'use_psfrag',false);
check_unsupported_options(options,mfilename);

if isempty( handle )
    handle=gca;
end
if ~ishandle( handle )
    error( 'sglib:save_figure', 'First argument  must be a handle' );
end
if isempty(figdir)
    warning( 'sglig:save_figure', 'figdir not set set. Set explicitly or via global variable sglib_figdir' );
    sglib_figdir=[getenv('HOME') '/projects/docs/stochastics/thesis/figures'];
end
if nargin<3
    type='eps';
end

common_params={'figdir', figdir};

if strcmp( get( handle, 'type' ), 'axes' )
    [newaxis,newfig]=reparent_axes( handle ); %#ok<ASGLU>
    handle=newfig;
else
    newfig=[];
end
check_handle( handle, 'figure' );
set( handle, 'renderer', 'painters' );

if use_psfrag
    psfrag_list=psfrag_format( handle );
    latex_params=[latex_params, {'psfrag_list', psfrag_list}];
else
    latex_format( handle );
    %disp( 'latex_format figure' );
end

pngfilename=make_filename( name, figdir, 'png' );
epsfilename=make_filename( name, figdir, 'eps' );
texfilename=make_filename( name, figdir, 'tex' );

png_params=[common_params, png_params];
eps_params=[common_params, eps_params];
latex_params=[common_params, latex_params];

save_png( handle, name, png_params{:} );
if strcmp(type,'png')
    convert_png_eps( pngfilename, png2eps_params{:} );
else
    save_eps( handle, name, eps_params{:} );
end
save_latex( texfilename, epsfilename, latex_params{:} );

close( newfig );


function latex_format( handle )
h_text  = findall(handle, 'type', 'text');
h_axes  = findall(handle, 'type', 'axes');
h_font   = [h_text; h_axes];

set( h_text, 'interpreter', 'latex' );
set( h_font, 'fontunits', 'points' );
set( h_axes, 'fontsize', 12 );
set( h_text, 'fontsize', 16 );
%set( h_font, 'fontname', 'times new roman' );
%set( h_font, 'fontname', 'bookman' );
set( h_font, 'fontname', 'new century schoolbook' );
set( h_font, 'fontweight', 'normal' );

