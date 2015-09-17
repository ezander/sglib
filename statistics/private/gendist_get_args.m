function varargout=gendist_get_args(dist, params)
% GENDIST_GET_ARGS Internal function to parse to arguments of gendist.
%   GENDIST_GET_ARGS returns the parameters for the gendist functions.
%   Unspecified parameters are replaced by their defaults (SCALE=1,
%   SHIFT=0, PARAMS={}) and the MEAN is computed if it wasn't specified.
%   The function can be called as [DISTNAME, PARAMS, SHIFT, SCALE,
%   MEAN]=GENDIST_GET_ARGS(DIST, PARAMS) or as
%   [ARGS]=GENDIST_GET_ARGS(DIST, PARAMS), where ARGS is a cell array.
%
% Example (<a href="matlab:run_example gendist_get_args">run</a>)
%   % See the unittest
% See also GENDIST_CREATE

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if ischar(dist)
    warning('sglib:statistics:gendist', 'Old style calling convention used');
    dist = {dist, params{:}};
elseif iscell(dist) && (nargin<2 || isempty(params))
    % ok nothing to do
else
    error('sglib:statistics:gendist', 'Invalid arguments');
end

if length(dist)<2 || isempty(dist{2}) % params
    dist{2} = {};
end
if length(dist)<3 || isempty(dist{3}) % shift
    dist{3} = 0;
end
if length(dist)<4 || isempty(dist{4}) % scale
    dist{4} = 1;
end
if length(dist)<5 || isempty(dist{5}) % mean
    dist{5} = gendist_mean(dist{1}, dist{2});
end

if nargout==1
    varargout = {dist};
else
    varargout = dist;
end

function m=gendist_mean(dist, params)
m=feval( [dist '_moments'], params{:} );
