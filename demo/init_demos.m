function init_demos( experimental )

% INIT_DEMOS Set some parameters for the demos to run correctly.
%   Currently only adds paths to the normal matlab search path. Maybe later
%   we could also look for an optional user options file and read that in.
%
% Example
%   init_demos
%
% See also 

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% persistent run_first
% if ~isempty(run_first)
%     return
% end
% run_first=false;

p = mfilename('fullpath');
m=find(p=='/',2,'last');
p=p(1:m(1)-1);

addpath( p );
addpath( [p '/munit'] );
addpath( [p '/util'] );
addpath( [p '/simplefem'] );
addpath( [p '/plot'] );

if isoctave()
    addpath( [p '/octcompat'] );
end

if nargin>=1 && ~isempty(experimental) && experimental
    addpath( [p '/experimental'] );
end

