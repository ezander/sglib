function plot_field( els, pos, u, varargin )
% PLOT_FIELD Plots a field given on a triangular mesh.
%   PLOT_FIELD( ELS, POS, U, VARARGIN ) plots the field given in U on the
%   nodes given in POS performing interpolation on the triangles given in
%   ELS. Certain formatting options can be specified in the remaining
%   arguments:
%
%      view: (default: 2, straight from top) set the view position, check
%        the matlab view command for settings, good is also for eg. [30,15]
%        for a view angle of 15 degrees from above and 30 degrees from the
%        right (degrees, not radians!)
%      show_mesh: (default: true) whether the mesh should be plotted
%      show_surf: (default: true) whether the surface should be plotted
%      shading: (default: 'interp') the shading mode for the surface, other
%        modes are 'flat' and 'faceted' (keese)
%      lighting: (default: 'flat') the lighting mode for the surface
%      colormap: (default: 'jet') the colormap mode for the surface,
%      axis: (default: 'square') the axis command ('equal')
%      default ranges from blue over green, yellow to res (keese uses
%        'cool', ranging from turquoise to magenta)
%      draw_now: (default: true) draws immediately, can be set to false to
%        speed things up, if many plots have to be made
%      wait: (default: false) wait for the user to press a button or click
%        the mouse using the current "userwaitmode"
%
% Example (<a href="matlab:run_example plot_field">run</a>)
%
% See also VIEW, SHADING, LIGHTING, COLORMAP, AXIS, USERWAIT, SETUSERWAITMODE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


check_boolean( size(els,2)==3, 'elements must be triangles (size(els,2)==3)', mfilename );
check_range( size(pos,2), 2, 2, 'sizeof(pos,2)', mfilename );
check_boolean( size(pos,1)==size(u,1), 'number of points must equal number of values (size(u,1)==size(pos,1))', mfilename );


options=varargin2options( varargin{:} );
[view_mode,options]=get_option( options, 'view', 2 );
[show_mesh,options]=get_option( options, 'show_mesh', true );
[show_surf,options]=get_option( options, 'show_surf', true );
[shading_mode,options]=get_option( options, 'shading', 'interp' );
[lighting_mode,options]=get_option( options, 'lighting', 'flat' );
[map,options]=get_option( options, 'colormap', 'jet' );
[axis_mode,options]=get_option( options, 'axis', 'square' );
[draw_now,options]=get_option( options, 'draw_now', true );
[wait,options]=get_option( options, 'wait', false );
check_unsupported_options( options, mfilename );


if ismatlab()
    ut=sum(u(els),2)/3;
    un=pdeprtni(pos',els',ut');

    if show_mesh
        %trimesh( els, pos(:,1), pos(:,2), u );
        trimesh( els, pos(:,1), pos(:,2), u );
        if show_surf
            hold on
        end
    end
    if show_surf
        trisurf( els, pos(:,1), pos(:,2), u );
        if show_mesh
            hold off
        end
    end
    view(view_mode);
    axis( axis_mode );
    xlim([min(pos(:,1)) max(pos(:,1))]);
    ylim([min(pos(:,2)) max(pos(:,2))]);
    shading( shading_mode );
    lighting( lighting_mode );
    colormap( map );
    if draw_now || wait
        drawnow;
    end
    if wait
        userwait
    end
else
    fprintf('plot_field not yet implemented for octave\n');
end
