function path=cache_file_base()
% CACHE_FILE_BASE Returns the base path where cache files are stored.
%   CACHE_FILE_BASE Returns the base path where cache files are stored.
%
% Example (<a href="matlab:run_example cache_file_base">run</a>)
%   path=cache_file_base();
%   filename=fullfile( path,  'foobar.mat' );
%   save( filename );
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

USER=getenv( 'USER' );
path=fullfile( tempdir, ['sglib-' USER], 'cache' );
