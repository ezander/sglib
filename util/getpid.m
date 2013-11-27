function pid=getpid()
% GETPID Returns the process id (PID) of this Matlab process.
%   PID=GETPID Returns the process id (PID) of this Matlab process. Only
%   works on unix systems. On windows systems a -1 is returned.
%
% Example (<a href="matlab:run_example getpid">run</a>)
%   pid=getpid();
%   fprintf('The current matlab process has PID: %d\n', pid);
%
% See also SYSTEM

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

if isunix
    [stat,result]=system('echo $PPID');
    if stat~=0 
        warning( 'sglib:getpid', 'Could not determine PID (status code: %d). Reason: %s', stat, result );
        pid=-1;
    else
        pid=str2num(result);
    end
else
    warning( 'sglib:getpid', 'Cannot determine PID on non-Unix systems.' );
    pid=-1;
end
