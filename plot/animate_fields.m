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
[zrange, options]=get_option( options, 'zrange', [] );
[dynamicz,options]=get_option( options, 'dynamicz', true );
[titles,options]=get_option( options, 'titles', {} );
check_unsupported_options( options, mfilename );

if iscell(zrange) && isempty(zrange)
    zrange=cell(length(fields));
end

N=200;
L=500;
m=size(fields{1}{end},2);
xi_N=randn(m,N);
%pp = interp1(linspace(1,L,N),xi_N','spline','pp');
pp = interp1(linspace(0,1,N),xi_N','spline','pp');

clf;
animation_control( 'start', gcf );
set( gcf, 'Renderer', renderer );
cols=ceil(length(fields)/rows);


% for i=1:L
%     xi=ppval(pp,i);
for t=linspace(0,1,L)
    xi=ppval(pp,t);
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
        
        if j<=length(titles)
            title(titles{j});
        end
        
        if iscell(zrange)
            zr=zrange{j};
        else
            zr=zrange;
        end
        if dynamicz
            zr=minmax( [zr, u(:)'] );
        end
        if ~isempty(zrange)
            zlim(zr);
            caxis(zr);
        end
        if iscell(zrange)
            zrange{j}=zr;
        else
            zrange=zr;
        end
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

function mm=minmax( x )
mm=[min(x), max(x)];

