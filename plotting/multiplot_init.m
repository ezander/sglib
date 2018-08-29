function mh=multiplot_init( m, n, varargin )
% MULTIPLOT_INIT Initialises a multiplot grid.
%   MULTIPLOT_INIT(M,N,OPTIONS) initialises a grid for outputting multiple
%   plots. This functions is meant as a more convenient alternative to
%   the builtin SUBPLOT command, because one has not to specify the grid
%   layout again and again (as in SUBPLOT). OTOH it has slightly less
%   flexibility, which is IMHO seldom needed.
%
% Options
%   ordering: 'row', {'col'}, 'column'
%     Indicates the activation order of the plots. If 'row' is specified
%     the plots are activated by first activating row 1 from left to right
%     then row 2, row 3, and so on. If 'col' or 'column' are specified then
%     first column 1 is activated from top to bottom, the col 2 and so on.
%     This is the same ordering as usual in the SUBPLOT command.
%   title: ''
%     Add an additional title to the top of the figure. For adjustment of
%     the sizes and placements of the subplots, there are the additional
%     options 'title_dist', 'title_height_diff', and 'title_ypos_diff'. To
%     understand their effect, please try them out.
%   separate_figs: {false}, true
%     If set to true, the plots won't go into subplots, but into separate
%     figures. This is useful, when you want to save your figures to a
%     files, because you can just leave you MULTIPLOT_INIT and MULTIPLOT
%     statements where they are and just flip this option.
%
% Example (<a href="matlab:run_example multiplot_init">run</a>)
%     multiplot_init(3,2, 'title', 'Sin functions', 'title_dist', 0.02)
%     x=linspace(0,10);
%     for i=1:6
%         multiplot;
%         plot(x,sin(i*x));
%         title(strvarexpand('sin($i$x)'));
%     end
%
% See also MULTIPLOT, MULTIPLOT_ADJUST_RANGE, SUBPLOT

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin>=2 
    if ischar(n) || iscell(n)
        varargin = [n, varargin];
        n = [];
    end
end

options=varargin2options(varargin, mfilename);
[ordering, options]=get_option(options, 'ordering', 'col');
[figtitle, options]=get_option(options, 'title', []);
[title_dist, options]=get_option(options, 'title_dist', 0.01);
[title_height_diff, options]=get_option(options, 'title_height_diff', 0);
[title_ypos_diff, options]=get_option(options, 'title_ypos_diff', 0.03);
[separate_figs, options]=get_option(options, 'separate_figs', false);
check_unsupported_options(options);

if nargin==1 || isempty(n)
    mn=m;
    m=round( sqrt(mn) );
    n=ceil( mn/m );
end

switch(ordering)
    case {'column', 'col'}
        % column by column means increasing the row-index first
        row_first = true;
    case 'row'
        % row by row means increasing the column-index (and not the
        % row-index) first
        row_first = false;
    otherwise
        error('sglib:multiplot_init', 'Unknown ordering: "%s"', ordering);
end

% clear the current figure
if separate_figs
    fh=[];
else
    fh=clf;
end
%set( fh, 'defaulttextinterpreter', 'latex' );

have_title=~isempty(figtitle);
if have_title && ~separate_figs
    add_m = 1;
    subplot(m+add_m, n, 1:n);
    height = set_title(figtitle);
    height = height - title_dist;
    add_height = height/m + title_height_diff;
    diff_ypos = height/m + title_ypos_diff;
else
    add_m = 0;
end

% initialise the figures
if separate_figs
    [handles{1:m,1:n}]=multifigure;
    fh=cellfun(@double, handles);
end


%handles=zeros(m,n);
handles = gobjects(m, n);
for i=1:m
    for j=1:n
        if ~separate_figs
            % compute linear index for subplot
            k=j+n*(i-1+add_m);
            h=subplot( m+add_m, n, k );
            h.Visible = 'off';
            % store the handle
            handles(i,j)=h;
            if have_title
                move_axis(h, add_height, (m-i)*diff_ypos);
            end
        else
            figure(fh(i,j));
            h=subplot( 1, 1, 1 );
            handles(i,j)=h;
        end
    end
end

% store administrative data
mp_data.handles = handles;
mp_data.m = m;
mp_data.n = n;
mp_data.i = 0;
mp_data.j = 0;
mp_data.row_first = row_first;
mp_data.fh = fh;

multiplot_data('set', mp_data);

% return the handles array 
if nargout>0
    mh=mp_data.handles;
end

function height=set_title(figtitle)
set(gca, 'Visible', 'off')
h=title(figtitle);
set(h, 'Visible', 'on')

pos = get(gca, 'Position');
height=pos(4);
pos(4) = 0;
pos(2) = pos(2)+height;
set(gca, 'Position', pos);

function move_axis(h, add_height, diff_ypos)
pos = get(h, 'Position');
pos(4) = pos(4) + add_height;
pos(2) = pos(2) + diff_ypos;
set(h, 'Position', pos);
