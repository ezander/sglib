function t=timers(action, timer, varargin)
% TIMERS Allows starting and stopping of timers for performance measurements.
%   TIMERS( ACTION, TIMER ) performs the action ACTION on the timer
%   identified TIMER by the string TIMER, which must be a valid matlab
%   identifier. Actions are strings but have also a numerical equivalent.
%   Valid actions are: 
%     'reset', 0: reset the timer to 0 and stops it
%     'start', 1: starts the timer, if stopped, otherwise does nothing
%     'stop',  2: stops the timer if running
%     'get',   3: returns the currently elapsed time for this timer
%   This function tries to be nice to the user and does not enforce, e.g.
%   to use 'stop' before you can call 'start' again, or use 'reset' before
%   you can use the timer. You can even use 'get' without having ever used
%   the timer, in which case it just returns 0.
%
%   Further, actions that are not specific for one timer are: 
%     'getall', 4: returns the complete timer struct
%     'resetall', 5: resets all timers
%
% Example (<a href="matlab:run_example timers">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

persistent ts

if isempty(ts)
    ts=struct();
end

if exist( 'timer', 'var' )
    if ~isfield(ts,timer)
        ts.(timer).time=0;
        ts.(timer).tic=-1;
        ts.(timer).run=0;
        ts.(timer).data=struct();
    end
end

switch action
    case {0,'reset'}
        ts.(timer).time=0;
        ts.(timer).tic=-1;
        ts.(timer).run=0;
        ts.(timer).data=struct();
    case {1,'start'}
        if ts.(timer).run==0
            ts.(timer).tic=tic;
        end
        ts.(timer).run=ts.(timer).run+1;
    case {2,'stop'}
        if ts.(timer).run>0
            ts.(timer).run=ts.(timer).run-1;
            if ts.(timer).run==0
                add=toc(ts.(timer).tic);
                ts.(timer).time=ts.(timer).time+add;
            end
        end
    case {3,'get'}
        add=0;
        if ts.(timer).run>0
            add=toc(ts.(timer).tic);
        end
        t=ts.(timer).time+add;
    case {4,'getall'}
        t=struct();
        names=sort( fieldnames(ts) );
        for i=1:length(names)
            timer=names{i};
            t.(timer)=timers( 'get', timer );
        end
    case {5,'resetall'}
        ts=struct();
    case {'adddata'}
        assert(length(varargin)==2);
        key = varargin{1};
        value = varargin{2};
        ts.(timer).data.(key) = value;
    case {'getdata'}
        t=struct();
        names=sort( fieldnames(ts) );
        for i=1:length(names)
            timer=names{i};
            t.(timer)=ts.(timer).data;
        end
    otherwise
        error( 'timers:wrong_param', 'Unknown action for timers: %s', action );
end
