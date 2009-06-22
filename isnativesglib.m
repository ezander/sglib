function bool=isnativesglib
% ISNATIVESGLIB Return whether native sglib functions are used.
%   ISNATIVESGLIB returns 1 if the native sglib functions are used and
%   are the first on the search path. Obviously, this (non-native)
%   implementation always returns 0. 
%
% Note: is function is currently not really used. It was (and is) intended
%   to be able to differentiate between an implementation that uses
%   external code (MEX files for matlab, or OCT files for octave), and code
%   the uses only script files.
%
%
% Example (<a href="matlab:run_example isnativesglib">run</a>)
%   if isnativesglib
%     sprintf( 'native sglib is being used' );
%   end
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


% If this script gets called the native stuff is not the
% first on the search path or not there at all, so return
% false.
bool=0;
