function cmds=run_example( cmd, varargin )
% RUN_EXAMPLE Runs the example for a command.
%   If the help output for CMD contains an example section, running
%   RUN_EXAMPLE( CMD ) will extract this section and run it in the current
%   workspace. This feature be can also directly included in the command
%   help. E.g. if you specify:
%
%     %  Example (<a href="matlab:run_example CMD">run</ a>)
%     %     now come the example commands ...
%
%   in your help file, the user can click directly on (run), which is
%   displayed as link, and invoke the example (Note: remove the blank in
%   </ a>).
%
% Example 1 (<a href="matlab:run_example run_example">run</a>)
%     disp( 'running the example section of erase_print:' );
%     run_example erase_print
%
% See also HELP

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

show=false;
num='';

for i=1:length(varargin)
    extra = varargin{i};
    switch extra
        case 'show'
            show = true;
        case {'1', '2', '3', '4', '5', '6', '7', '8', '9'}
            num = [' ', extra];
        case ''
            % do noting
    end
end
    
s=help(cmd);

[x1,x2]=regexp( s, ['\n *Example' num '.*?\n'] );
if isempty(x1);
    if isempty(num)
        warning( 'run_example:not_found', 'No sample section found in: %s', cmd );
    else
        warning( 'run_example:not_found', 'Sample section %s not found in: %s', num, cmd );
    end
    return;
end
s=s(x2(1)+1:end);

x1=regexp( s, '\n *(See also|Run|References|Example|Note)' );
if ~isempty(x1)
    s=s(1:x1(1)-1);
end
if ~show
    evalin( 'base', s );
else
    fprintf( 'Sorry, the example code cannot be run directly (probably some function decls inside).\n' );
    fprintf( 'Maybe you should copy and paste it into an m-file of your own.\n\n' );
    fprintf( '%s\n', s);
end

if nargout==1
    cmds=s;
end
