function h=plot_field( pos, els, u, varargin )
% PLOT_FIELD Plots a field given on a triangular mesh.
%   PLOT_FIELD( POS, ELS, U, VARARGIN ) plots the field given in U on the
%   nodes given in POS performing interpolation on the triangles given in
%   ELS. Certain formatting options can be specified in the remaining
%   arguments:
%
% Options:
%    view: {2="straight from top"}
%      Set the view position, check the matlab VIEW command for settings,
%      good is also for eg. [30,15] for a view angle of 15 degrees from
%      above and 30 degrees from the right (note: degrees, not radians!)
%    show_mesh: {true}, false
%      Determines whether the mesh should be plotted.
%    show_surf: {true}, false
%      Determines whether the surface should be plotted.
%    shading: {'interp'}, 'flat', 'faceted'
%      Sets the shading mode for the surface, other modes are 'flat' and
%      'faceted' (keese)
%    lighting: 'flat', 'gouraud', 'phong', {'none'}
%      Sets the lighting mode for the surface.
%    colormap: {'jet'}, 'cool', 'grey', ...
%      Sets the colormap mode for the surface. The default ranges from
%      blue over green, yellow to res (Keese uses 'cool', ranging from
%      turquoise to magenta).
%    axis: {'square'}, 'equal', ...
%      Set the axis.
%    draw_now: {true}, false
%      Draws immediately, can be set to false to speed things up, if many
%      plots have to be made.
%    Wait: true, {false}
%      Wait for the user to press a button or click the mouse using the
%      current "userwaitmode".
%
% Example (<a href="matlab:run_example plot_field">run</a>)
%
% See also VIEW, SHADING, LIGHTING, COLORMAP, AXIS, USERWAIT, SETUSERWAITMODE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


check_boolean( size(els,1)==3, 'elements must be triangles (size(els,1)==3)', mfilename );
check_range( size(pos,1), 2, 2, 'sizeof(pos,2)', mfilename );
check_boolean( size(pos,2)==size(u,1), 'number of points must equal number of values (size(u,1)==size(pos,2))', mfilename );


options=varargin2options( varargin );
[view_mode,options]=get_option( options, 'view', 2 );
[show_mesh,options]=get_option( options, 'show_mesh', true );
[shading_mode,options]=get_option( options, 'shading', 'interp' );
[lighting_mode,options]=get_option( options, 'lighting', 'none' );
[map,options]=get_option( options, 'colormap', 'parula' );
[axis_mode,options]=get_option( options, 'axis', 'square' );
check_unsupported_options( options, mfilename );


if ismatlab()
    u1 = min(u(:)); u2 = max(u(:));
    if u2>u1
        c = (u-u1)/(u2-u1);
    else
        c = u;
    end
    h = trisurf( els', pos(1,:), pos(2,:), u, c );
    ha = gca;
    view( ha, view_mode );
    axis( ha, axis_mode );
    xlim( ha, [min(pos(1,:)) max(pos(1,:))]);
    ylim( ha, [min(pos(2,:)) max(pos(2,:))]);
    shading( shading_mode );
    if ~strcmp(lighting_mode, 'none')
        light(ha);
        lighting( ha, lighting_mode );
    end
    colormap( ha, map );
    if show_mesh
        set( h, 'Edgecolor', 'k');
    end
else
    fprintf('plot_field not yet implemented for octave\n');
end

if nargout==0
    clear('h');
end
