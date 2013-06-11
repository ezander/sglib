function [mode,msg,func]=setuserwaitmode( mode, msg, func )
% USERWAIT Sets the wait mode for USERWAIT.
%   Sets the mode for the USERWAIT function. It can be specified that the
%   wait function waits for a keyboard event (usually via the PAUSE
%   function), for a mouse click (usually via WAITFORBUTTONPRESS) or does
%   nothing at all. Further a user specified function can be invoked and a
%   msg do be displayed at each USERWAIT invocation can be set.
%
%   One idea for the function would be to automatically save the current
%   graphics to a file with some automatically incremented counter. The
%   parameter MSG is in this case irrelevant.
%
% Example (<a href="matlab:run_example setuserwaitmode">run</a>)
%   % set USERWAIT to wait for the keyboard
%   setuserwaitmode( 'keyboard' )
%   % set USERWAIT to wait for the mouse and display a message
%   setuserwaitmode( 'mouse', 'Press mouse button to continue...' )
%   % set USERWAIT to continue processing without halting
%   setuserwaitmode( 'continue' )
%   % set USERWAIT to not wait but process some userdefined function
%   setuserwaitmode( 'function', '', {@disp,{''}} )
%   setuserwaitmode( 'function', '', @save_as_eps )
%   % query the SETUSERWAITMODE state
%   [mode,msg,func]=setuserwaitmode( 'getmode' )
%   [mode,msg,func]=setuserwaitmode()
%
% See also USERWAIT

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


persistent init_done save_mode save_msg save_func

if isempty(init_done)
    init_done=true;
    save_mode=1;
    save_msg='Press any key to continue...';
    save_func=[];
end

if nargin==0 || strcmp( mode, 'getmode' )
    mode=save_mode;
    msg=save_msg;
    func=save_func;
    return;
end

switch mode
    case {1, 'keyboard'}
        save_mode=1;
        if nargin<2
            save_msg='Press any key to continue...';
        end
    case {2, 'mouse'}
        save_mode=2;
        if nargin<2
            save_msg='Press any key or click mouse to continue...';
        end
    case {3, 'continue'}
        save_mode=3;
    case {4, 'function'}
        save_mode=4;
        if nargin<3
            error( 'userwaitmode:nofunc', 'function mode specified in setuserwaitmode but no function passed as parameter' );
        end
    otherwise
        error( 'userwaitmode:unknown', 'unknown mode specified in setuserwaitmode' );
end

if nargin>=2
    save_msg=msg;
end

if nargin>=3
    if ~iscell(func)
        save_func={func};
    else
        save_func=func;
    end
end
