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
%
% Example (<a href="matlab:run_example multiplot_init">run</a>)
%
% See also SUBPLOT

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

options=varargin2options(varargin, mfilename);
[ordering, options]=get_option(options, 'ordering', 'col');
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
fh=clf;
%set( fh, 'defaulttextinterpreter', 'latex' );

% initialise the figures
handles=zeros(m,n);
for i=1:m
    for j=1:n
        % compute linear index for subplot
        k=j+n*(i-1);
        h=subplot( m, n, k ); 
        % store the handle
        handles(i,j)=h;
    end
end

% store administrative data
mp_data.handles = handles;
mp_data.m = m;
mp_data.n = n;
mp_data.i = 0;
mp_data.j = 0;
mp_data.row_first = row_first;
multiplot_data('set', mp_data);

% return the handles array 
if nargout>0
    mh=mp_data.handles;
end
