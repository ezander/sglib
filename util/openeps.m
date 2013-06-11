function openeps( filename )
% OPENEPS Handler for opening EPS files from Matlab's OPEN function.
%   OPENEPS( FILENAME ) open the EPS file given by FILENAME in a PostScript
%   viewer application (which is currently hardcoded to gv). Usually you
%   don't call this method directly, but rather OPEN(FILENAME) and OPEN
%   selects the correct OPENXXX handler based on the files extension.
%
% Example (<a href="matlab:run_example openeps">run</a>)
%   spy;
%   filename=[tempname '.eps'];
%   print( filename, '-depsc2' );
%   open( filename );
%   delete( filename );
%
% See also OPEN

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

viewer_cmd='gv %s';
exec=sprintf( viewer_cmd, filename );
system( exec );
