function bool=never
% NEVER Returns false.
%   NEVER always returns false. Use it to comment out code without mlint
%   complaining about unreachable code.
%
% Example (<a href="matlab:run_example never">run</a>)
%   if never
%      disp( 'do something obsolete' );
%   end
%   disp( 'Did you see anything?' );
%
% See also SWALLOW

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

bool=false;
