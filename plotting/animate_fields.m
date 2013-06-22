function animate_fields( pos, els, fields, varargin )
% ANIMATE_FIELD Short description of animate_field.
%   ANIMATE_FIELD Long description of animate_field.
%
% Example (<a href="matlab:run_example animate_field">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


options=varargin2options( varargin );
[rows, options]=get_option( options, 'rows', -1 );
[cols, options]=get_option( options, 'cols', -1 );
[renderer, options]=get_option( options, 'renderer', 'zbuffer' );
[view_mode, options]=get_option( options, 'view_mode', 3 );
[zrange, options]=get_option( options, 'zrange', [] );
[dynamicz,options]=get_option( options, 'dynamicz', true );
[mask,options]=get_option( options, 'mask', [] );
[titles,options]=get_option( options, 'titles', {} );
[xlabels,options]=get_option( options, 'xlabels', {} );
[ylabels,options]=get_option( options, 'ylabels', {} );
check_unsupported_options( options, mfilename );

fields=fields(:);

if iscell(zrange) && isempty(zrange)
    zrange=cell(length(fields),1);
end

N=200;
L=1500;
m=size(fields{1}{end},2);
xi_N=randn(m,N);
if ~isempty(mask)
    imask=~mask;
    xi_N(imask,:)=repmat(xi_N(imask,1),1,N);
end
pp = interp1(linspace(0,1,N),xi_N','spline','pp');


dynamicsub=false;
if cols==-1
    if rows==-1 % F=rows*cols; cols/rows=3/2; F=3/2*rows^2
        dynamicsub=true;
    else
        cols=ceil(length(fields)/rows);
    end
elseif rows==-1
    rows=ceil(length(fields)/cols);
end


animation_control( 'start', gcf );
set( gcf, 'Renderer', renderer );
set( gcf, 'WindowButtonUpFcn', @stop_animation );

first=true;
for t=linspace(0,1,L)
    if dynamicsub
        winpos=get(gcf,'Position');
        ratio=winpos(4)/winpos(3);
        newrows=floor( sqrt( ratio*length(fields) ) + max(1-ratio/2,0) );
        newcols=ceil(length(fields)/newrows);
        if newrows~=rows || newcols~=cols
            rows=newrows; cols=newcols;
            first=true;
        end
    end
    if first
        clf;
    end
    
    xi=ppval(pp,t);
    for j=1:length(fields)
        field=fields{j};
        switch length(field)
            case 3 % kl-pce
                u=kl_pce_field_realization( field{:}, xi );
            case 2 % pce
                u=pce_field_realization( field{:}, xi );
            case 1 % det field
                u=field{1};
            otherwise
                if first
                    warning( 'animate_fields:wrong_field', 'Wrong field struct at %d: length %d', j, length(field) );
                end
        end
        
        h=subplot(rows,cols,j);
        if first
            curr_view=view_mode;
        else
            curr_view=get(h,'view');
        end
        if first || length(field)>1
            plot_field( pos, els, u, 'lighting', 'gouraud', 'view', curr_view );
        end
        
        if j<=length(titles)
            title(titles{j});
        end
        if iscell(xlabels) && j<=length(xlabels)
            xlabel(xlabels{j});
        elseif ischar(xlabels)
            xlabel(xlabels);
        end
        if iscell(ylabels) && j<=length(ylabels)
            ylabel(ylabels{j});
        elseif ischar(ylabels)
            ylabel(ylabels);
        end
        
        zrange=set_and_update_range( zrange, dynamicz, j, u );
    end
    drawnow;
    
    if ~animation_control( 'check' )
        disp('quitting...');
        return
    end
    first=false;
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

function zrange=set_and_update_range( zrange, dynamicz,  j, u )
if iscell(zrange)
    zr=zrange{j};
else
    zr=zrange;
end
if dynamicz
    zr=minmax( [zr, u(:)'] );
end
if ~isempty(zrange) && zr(2)>zr(1)
    zlim(zr);
    caxis(zr);
end
if iscell(zrange)
    zrange{j}=zr;
else
    zrange=zr;
end

function mm=minmax( x )
mm=[min(x), max(x)];

