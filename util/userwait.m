function userwait()
% USERWAIT Wait for the user to press a button or klick the mouse.
%   Waits for the user to press a button or click the mouse (whatever was
%   specified in SETUSERWAITMODE). If the current script is published (see
%   PUBLISH) the function returns immediately.
%
% Example (<a href="matlab:run_example userwait">run</a>)
%   setuserwaitmode( 'keyboard', 'Press any key to continues...' );
%   % compute something, display results
%   userwait
%   % now continue computing ...
%
%
% See also SETUSERWAITMODE, PUBLISH

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

if feature('hotlinks')==0
    % We're probably in publish mode, so exit immediately. (The feature
    % function is undocumented, so this is a bit of guesswork).
    return
end

[mode,msg,func]=setuserwaitmode( 'getmode' );

switch mode
    case 1
        if ~isempty(msg); disp(msg); end
        pause
    case 2
        % There is a bug in matlab that causes the stdout buffer to
        % be flushed after waitforbuttonpress, causing the message to be
        % diplayed much too late.
        % TODO: find a workaround if possible
        if ~isempty(msg); disp(msg); end
        try
            waitforbuttonpress
        catch %#ok<CTCH>
            % do nothing, we just don't to have an error message displayed
            % or matlab jump into the debugger, just because the user
            % closed the window
            fprintf( '\nThe figure window was closed unexpectedly.\n' )
            fprintf( 'Do you want to abort this script? ' );
            fprintf( '<a href="matlab:evalc(''dbup'');dbquit">abort</a>  <a href="matlab:dbcont">continue</a>\n' );
            keyboard;
        end
    case 3
        % do nothing
    case 4
        funcall( func );
end

% TODO: good idea would be to have an ID with each userwait call and select
% the action based on the ID, or to be able to say skip all, skip all this
% ID, etc ...

