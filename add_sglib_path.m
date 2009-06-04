function basepath=add_sglib_path( octave, experimental, restore )
% ADD_SGLIB_PATH Set paths for sglib.
%   ADD_SGLIB_PATH( OCTAVE, EXPERIMENTAL ) adds paths for sglib to the
%   normal search path. If OCTAVE (default: FALSE) is true the path to the
%   octave compatibility directory (octcompat) is added. If EXERIMENTAL
%   (default: FALSE) is true the path to experimental directory is added.
%   If RESTORE (default: FALSE) is specified, the path is first reset to
%   its default.
%   
%
% Example (<a href="matlab:run_example add_sglib_path">run</a>)
%   % set default paths and return base path
%   p=add_sglib_path
%   % set default plus experimental path (but no octave)
%   add_sglib_path( false, true )
%   % set default plus octave path (but no experimental) resetting the path
%   % first
%   add_sglib_path( true, false, true )
%
% See also STARTUP

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin>=3 && ~isempty(restore) && restore
    restoredefaultpath;
end

p = mfilename('fullpath');
m=find(p=='/',1,'last');
p=p(1:m-1);
addpath( p );
addpath( [p '/munit'] );
addpath( [p '/doc'] );
addpath( [p '/plot'] );
addpath( [p '/util'] );
addpath( [p '/simplefem'] );

if nargin>=1 && ~isempty(octave) && octave
    addpath( [p '/octcompat'] );
end

if nargin>=2 && ~isempty(experimental) && experimental
    addpath( [p '/experimental'] );
end

if nargout>0
    basepath=p;
end
