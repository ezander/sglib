function varargout=multifigure(varargin)
% MULTIFIGURE Allows easy use and reuse of multiple figures with clutter.
%   [H1, H2, H3, ..., HN]=MULTIFIGURE(OPTIONS) creates as many figures as
%   there are variables in the output arguments. If figures had already
%   been created by MULTIFIGURE and are still valid, then those handles are
%   returned (reusing those figures). Otherwise new figures are opened.
%   Figures are by default docked to the IDE.
%
% Options:
%   dock: {true}, false
%     Specifies whether the figure should be docked or not.
%
% Example (<a href="matlab:run_example multifigure">run</a>)
%   % Please run the demo multiple times and try
%   % docking, undocking, tiling, closing etc. the figure windows
%   [h1, h2] = multifigure();
%   figure(h1);
%   image(50*rand(5)); colormap hot
%   figure(h2);
%   image(50*rand(10)); colormap summer
%   
% See also FIGURE, MULTIPLOT

%   Elmar Zander
%   Copyright 2015, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


options=varargin2options(varargin, mfilename);
[dockfigs,options]=get_option(options, 'dock', true);
check_unsupported_options(options);

% Here, all our figure handles are stored
persistent figs

% Allocate enough space for the figure handles
if isempty(figs)
    figs = cell(0,1);
end

nfig = nargout;
if length(figs)<nfig
    figs = [figs; cell(nfig-length(figs),1)];
end

% For each handle, check if still valid and open a new figure if necessary.
% Figures are only docked, if requested and the figure is not already open.
for i=1:nfig
    if isempty(figs{i}) || ~ishandle(figs{i})
        figs{i} = figure;
        if dockfigs
            dock(figs{i});
        end
    end
end

varargout = figs(1:nfig);
