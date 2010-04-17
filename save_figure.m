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
[tex_params, options]=get_option(options,'tex_params',{});
[figdir, options]=get_option(options,'figdir',sglib_figdir);
check_unsupported_options(options,mfilename);

if ~ishandle( handle )
    error( 'sglib:save_figure', 'First argument  must be a handle' );
end
if isempty(figdir)
    error( 'sglig:save_figure', 'figdir not set set. Set explicitly or via global variable sglib_figdir' );
end

common_params={'figdir', figdir};

if strcmp( get( handle, 'type' ), 'axes' )
    [newaxis,newfig]=reparent_axes( handle );
    handle=h_workfig;
else
    newfig=[];
end
check_handle( handle, 'figure' );

switch type
    case 'eps'
        save_eps( handle, name, common_params{:}, eps_params{:} );
    case 'png'
        save_png( handle, name, common_params{:}, png_params{:} );
    case 'texeps'
        save_eps( handle, name, common_params{:}, eps_params{:} );
        save_latex( handle, name, common_params{:}, latex_params{:} );
    case 'texpng'
        save_png( handle, name, common_params{:}, png_params{:} );
        save_latex( handle, name, common_params{:}, latex_params{:} );
    otherwise
        error( 'sglib:save_figure', 'Unknown figure type: %s', type );
end

close( newfig );
