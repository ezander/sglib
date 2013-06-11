function logfile=log_stop()
% LOG_STOP Short description of log_stop.
%   LOG_STOP Long description of log_stop.
%
% Example (<a href="matlab:run_example log_stop">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

diary( 'off' );
filename=get( 0, 'DiaryFile' );
if nargout>0
    logfile=filename;
else
    fprintf( 'Stopped logging to file: %s\n', filename );
end
