function same_scaling( handles, axes, varargin )
% SAME_SCALING Set the scaling to be the same across multiple plots.
%   SAME_SCALING adjusts different plots so that they have the same
%   scaling, making the displayed data much better comparable. There are
%   different ways to invoke the method:
%
%   SAME_SCALING( HANDLES ) sets all axes for all HANDLES  to have the same
%   range, i.e. all xlim, ylim, and zlim will be the same afterwards for
%   all HANDLES.
%
%   SAME_SCALING( HANDLES, AXES ) where AXES can be a string describing the 
%   axes to be modified e.g. 'x', 'y', 'yz', etc. modifies the ranges
%   only for the specified axes.
%
%   SAME_SCALING( HANDLES, AXES, OPTIONS ) passes some additional options.
%
% Options
%   range: [min, max], default: []
%     The range that all AXES for the given HANDLES are set to. If the
%     empty the range is determined automatically to encompass the maximum
%     range;
%
% Example (<a href="matlab:run_example same_scaling">run</a>)
%   clf
%   h1=subplot(2,1,1); x=linspace(0,3); plot(x, sin(x) ); grid on;
%   h2=subplot(2,1,2); x=linspace(1,2); plot(x, exp(x)-3 ); grid on;
%   disp('Now scaling x axis. Press a key to continue...'); pause;
%   same_scaling([h1, h2], 'x');
%   disp('Now scaling y axis. Press a key to continue...'); pause;
%   same_scaling([h1, h2], 'y');
%   disp('Now scaling all axes to [0.5,1.5]. Press a key to continue...'); pause;
%   same_scaling([h1, h2], 'xy', 'range', [0.5, 1.5]);
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
[def_range,options]=get_option(options, 'range', []);
check_unsupported_options(options);

% default is to scale all axis the same
if nargin<2
    axes='xyz';
end

% do nothing if
if isempty(handles)
    return
end

% make axis a column vector
handles=handles(:);

% process each axis
for axis=axes
    if isempty(def_range)
        range = get_range(handles, axis);
    else
        range = def_range;
    end
    set_range(handles, axis, range);
end

function range=get_range(handles, axis)
% GET_RANGE Get the range for the specified axis
for i=1:length(handles)
    lim=get( handles(i), [axis 'lim'] );
    if i==1
        range=lim;
    else
        range=[min([lim range]), max([lim range])];
    end
end

function set_range(handles, axis, range)
% SET_RANGE Set the range for the specified axis
for i=1:length(handles)
    set( handles(i), [axis 'lim'], range );
end
