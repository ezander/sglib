function log_flush(varargin)
% LOG_FLUSH Short description of log_flush.
%   LOG_FLUSH Long description of log_flush.
%
% Example (<a href="matlab:run_example log_flush">run</a>)
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

status=get(0,'Diary');
if strcmp( status, 'on' )
    diary( 'off' );
    diary( 'on' );
end
