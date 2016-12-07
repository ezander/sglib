function basepath=sglib_addpath( basepath, restore, add_octave_path )
% SGLIB_ADDPATH Set paths for sglib.
%   SGLIB_ADDPATH( BASEPATH, RESTORE, EXPERIMENTAL, OCTAVE ) adds paths for sglib to the
%   normal search path. If OCTAVE (default: FALSE) is true the path to the
%   octave compatibility directory (octcompat) is added. If EXERIMENTAL
%   (default: FALSE) is true the path to experimental directory is added.
%   If RESTORE (default: FALSE) is specified, the path is first reset to
%   its default.
%   This function is usually run rom the startup script SGLIB_STARTUP.
%
% Example (<a href="matlab:run_example sglib_addpath">run</a>)
%   % set default paths and return base path
%   p=sglib_addpath
%   % set default plus experimental path (but no octave)
%   sglib_addpath( [], true, true, false )
%   % set default plus octave path (but no experimental) resetting the path
%   % first
%   sglib_addpath( [], true, false, true )
%
% See also SGLIB_STARTUP, ADDPATH, STARTUP

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% set default arguments
if nargin<2 || isempty(restore)
    restore=true;
end
if nargin<3 || isempty(add_octave_path)
    add_octave_path=false;
end

% determine basepath if not given
if nargin<1 || isempty(basepath)
    basepath=fileparts( mfilename('fullpath') );
end

% set standard paths
if restore
    restoredefaultpath;
end

addpath( basepath );
addpath( fullfile( basepath, 'doc') );
addpath( fullfile( basepath, 'util') );
addpath( fullfile( basepath, 'munit') );
addpath( fullfile( basepath, 'mathutil') );
addpath( fullfile( basepath, 'quadrature') );
addpath( fullfile( basepath, 'pce') );
addpath( fullfile( basepath, 'gpc') );
addpath( fullfile( basepath, 'statistics') );
addpath( fullfile( basepath, 'sampling') );
addpath( fullfile( basepath, 'plotting') );
addpath( fullfile( basepath, 'linalg') );
addpath( fullfile( basepath, 'tensor') );
addpath( fullfile( basepath, 'operator') );
addpath( fullfile( basepath, 'solver') );
addpath( fullfile( basepath, 'sfem') );
addpath( fullfile( basepath, 'fem') );
addpath( fullfile( basepath, 'fem', 'simplefem') );
addpath( fullfile( basepath, 'fem', 'pdetool') );
addpath( fullfile( basepath, 'util', 'paramstudy') )

addpath( fullfile( basepath, 'objects') );
addpath( fullfile( basepath, 'objects', 'operators') );
addpath( fullfile( basepath, 'objects', 'statistics') );
addpath( fullfile( basepath, 'objects', 'bases') );
addpath( fullfile( basepath, 'objects', 'util') );

addpath( fullfile( basepath, 'methods') );
addpath( fullfile( basepath, 'methods', 'spectral') );
%addpath( fullfile( basepath, 'methods', 'direct') );
addpath( fullfile( basepath, 'methods', 'updating') );


if exist( fullfile( basepath, 'contrib'), 'dir' )
  addpath( fullfile( basepath, 'contrib') )
  addpath( fullfile( basepath, 'contrib', 'distmesh') )
end

if add_octave_path
    addpath( fullfile( basepath, 'util', 'octcompat') );
end

rehash;

% suppress output argument if unwanted
if nargout==0
    clear basepath;
end
