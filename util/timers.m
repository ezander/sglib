function t=timers(timer,action)
% TIMERS Short description of timers.
%   TIMERS Long description of timers.
%
% Example (<a href="matlab:run_example timers">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

persistent ts

if ~isfield(ts,timer)
    ts.(timer).time=0;
    ts.(timer).tic=-1;
end

switch action
    case {0,'reset'}
        ts.(timer).time=0;
        ts.(timer).tic=-1;
    case {1,'start'}
        if ts.(timer).tic==-1
            ts.(timer).tic=tic;
        end
    case {2,'stop'}
        if ts.(timer).tic~=-1
            add=toc(ts.(timer).tic);
            ts.(timer).time=ts.(timer).time+add;
        end
        ts.(timer).tic=-1;
    case {3,'get'}
        add=0;
        if ts.(timer).tic~=-1
            add=toc(ts.(timer).tic);
        end
        t=ts.(timer).time+add;
end
