function h=multiplot( i, j )
% MULTIPLOT Sets the next subplot as active.
%   MULTIPLOT (without arguments) sets the next plot in the grid defined by
%   MULTIPLOT_INIT as active. Wether the next plot is the one below or left
%   to the last active plot can be controlled by the ORDERING option in
%   MULTIPLOT_INIT.
%   
%   MULTIPLOT( K ) sets the Kth plot as active. The actual position depends
%   on the size of the grid defined by MULTIPLOT_INIT and the ordering.
%
%   MULTIPLOT( I, J ) sets the actual I, J position of the active plot in
%   the grid.
%
% Note
%   For more information on the multiplot stuff, please see the help to
%   MULTIPLOT_INIT.
%
% Example (<a href="matlab:run_example multiplot">run</a>)
%   multiplot_init(6, [], 'ordering', 'col');
%   x = linspace(-1,1);
%   for i=1:6
%      multiplot; plot(x, legendre(i-1, x));
%   end
%
% See also MULTIPLOT_INIT, MULTIPLOT_ADJUST_RANGE, SUBPLOT

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


% Get administrative data
mp_data = multiplot_data('get');
if ~isfield(mp_data, 'handles')
    error('sglib:multiplot', 'MULTIPLOT_INIT must be called before calling MULTIPLOT');
end

% Determine i, j "coordinate" of next plot
if nargin==0
    [i, j] = ij_next(mp_data);
elseif nargin==1 || isempty(j)
    if ishandle(i)
        [i, j] = ij_from_handle(i, mp_data);
    else
        [i, j] = ij_from_k(i, mp_data);
    end
elseif isempty(i)
    [i, j] = ij_from_k(j, mp_data);
else
    % just keep i, j as they are
end

% Store updated administrative data
mp_data.i = i;
mp_data.j = j;
multiplot_data('set', mp_data);

% Get and check the graphics handles
mh = mp_data.handles;
if ~all(all(ishandle(mh)))
    warning( 'Handles are invalid' );
    return
end

% Set the current axis to the one we determined
set( gcf, 'CurrentAxes', mh(i, j) );
drawnow;

% Return current handle if necessary
if nargout>0
    h = mh(i, j);
end


function [i,j] = ij_from_k(k, mp_data)
% IJ_FROM_K Get I,J coordinates from linear index K and current MP_DATA
if mp_data.row_first
    [i, j] = get_from_k(k, mp_data.m);
else
    [j, i] = get_from_k(k, mp_data.n);
end

function [i, j]=get_from_k(k, m)
% GET_FROM_K Get I,J coordinates from linear index K and given col size M
i = mod(k - 1, m) + 1;
j = floor((k - 1)/m) + 1;


function [i, j] = ij_from_handle(h, mp_data)
% IJ_FROM_HANDLE Get I,J coordinates from graphics handle H and current MP_DATA
mh = mp_data.handles;
k = find(mh==h, 1, 'first');
if isempty(k)
    warning('sglib:multiplot', 'Handle not found');
    k = 1;
end
[i,j] = ij_from_k(k, mp_data);


function [i,j] = ij_next(mp_data)
% IJ_NEXT Get next I,J coordinate current MP_DATA
i=mp_data.i; 
j=mp_data.j;
if i==0
    i = 1;
    j = 1;
    return;
end
if mp_data.row_first
    [i, j] = get_next(i, j, mp_data.m, mp_data.n);
else
    [j, i] = get_next(j, i, mp_data.n, mp_data.m);
end

function [i, j]=get_next(i, j, m, n)
% GET_NEXT Get next I,J coordinate for grid size M, N
if i<m
    i=i+1;
else
    i=1;
    if j<n
        j=j+1;
    else
        j=1;
    end
end
