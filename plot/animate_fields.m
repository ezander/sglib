function animate_fields( pos, els, fields, varargin )
% ANIMATE_FIELD Short description of animate_field.
%   ANIMATE_FIELD Long description of animate_field.
%
% Example (<a href="matlab:run_example animate_field">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


options=varargin2options( varargin );
[rows, options]=get_option( options, 'rows', 1 );
[renderer, options]=get_option( options, 'renderer', 'zbuffer' );
[view_mode, options]=get_option( options, 'view_mode', 3 );
check_unsupported_options( options, mfilename );

N=200;
m=size(fields{1}{end},2);
xi_N=randn(m,N);
pp = interp1(linspace(1,500,N),xi_N','spline','pp');

clf;
animation_control( 'start', gcf );
set( gcf, 'Renderer', renderer );
cols=ceil(length(fields)/rows);


for i=1:1000
    xi=ppval(pp,i);
    %xi=(xi-mean(xi))/sqrt(var(xi))+mean(xi);
    for j=1:length(fields)
        field=fields{j};
        if length(field)==3
            u=kl_pce_field_realization( field{1:3}, xi );
        else
            u=pce_field_realization( field{1:2}, xi );
        end
        subplot(rows,cols,j);
        plot_field( pos, els, u, 'lighting', 'gouraud', 'view', view_mode );
        zlim([-3,3]);
        caxis([-3,3]);
    end
    drawnow;
    
    if ~animation_control( 'check' )
        disp('quitting...');
        return
    end
end


function ret=animation_control( cmd, varargin )
if isoctave
    error( 'animation_control:no_octave_yet', 'This does not work with Octave yet.' );
end
switch cmd
    case 'start'
        set( gcf, 'WindowButtonUpFcn', @stop_animation );
        set( gcf, 'UserData', 1 );
        disp('Click into the graphics window to stop the demo...' );
    case 'check'
        h=get(0,'CurrentFigure');
        if h
            ret=~isempty( get( h, 'UserData' ) );
        else
            ret=false;
        end
    case 'stop'
        h=get(0,'CurrentFigure');
        if h
            set( h, 'UserData', [] );
        end
end


function stop_animation(src,evt) %#ok
set( gcf, 'UserData', [] );
