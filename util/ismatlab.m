function bool=ismatlab()
% ISMATLAB Determine whether Matlab is running (and not octave).
%   BOOL=ISMATLAB() returns true if the current running interpreter/engine
%   is Matlab.
%
% Note: Currently checks for the non-existence of the 'octave_config_info'
%   builtin command, which is only implemented in Octave as yet. Not
%   foolproof, but probably good enough.
%
% Example (<a href="matlab:run_example ismatlab">run</a>)
%   if ismatlab()
%     % perform matlab specific code;
%   end
%
% See also ISOCTAVE

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


% does not work any more with octave 2.9.13
% bool=true;
% eval( 's=ver;', 'bool=false;' );

bool=(exist('octave_config_info', 'builtin')==0);
