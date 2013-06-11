function bool=isoctave()
% ISOCTAVE Determine whether Octave is running (and not Matlab).
%   BOOL=ISOCTAVE() returns true if the current running interpreter/engine
%   is Octave.
%
% Example (<a href="matlab:run_example isoctave">run</a>)
%   if isoctave()
%     % perform octave specific code;
%   end
%
% See also ISMATLAB

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


bool=~ismatlab();
