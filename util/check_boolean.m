function ok=check_boolean( ok, message, mfilename, varargin )
% CHECK_BOOLEAN Check whether condition is true on input.
%   OK=CHECK_BOOLEAN( COND, MESSAGE, MFILENAME ) checks whether the given condition
%   is true. If not an error message is printed and the program is aborted.
%
%   Note: pass mfilename literally for the last argument (i.e. pass the
%   return value of the buildin function 'mfilename' which tells you the
%   name of the current script, and is thus exactly what you want.)
%
% Example (<a href="matlab:run_example check_boolean">run</a>)
%   function my_function( str )
%
%     check_boolean( strcmp(str,str(end:-1:1)), 'str must be a palindrome', mfilename );
%
% See also CHECK_RANGE, CHECK_CONDITION, CHECK_UNSUPPORTED_OPTIONS

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% save some time by returning immediately if ok is true
if ok
    return
end

options=varargin2options( varargin{:} );
[mode,options]=get_option( options, 'mode', 'debug' );
[depth,options]=get_option( options, 'depth', '1' );
check_unsupported_options( options, mfilename );

switch mode
    case 'error'
        stack=dbstack('-completenames');
        err_struct.message=sprintf( '%s: %s', mfilename, message );
        err_struct.id=[mfilename ':condition'];
        err_struct.stack=stack((1+depth):end);
        % using 'rethrow' instead of 'error' suppresses incorrect
        % reports of error position in 'check_condition' (the 'error'
        % function disregards the stack for display of the error
        % position)
        rethrow( err_struct );
    case 'warning'
        %warning([mfilename ':condition'], '%s: %s', mfilename, message );
        fprintf('Warning: %s: %s\n', mfilename, message );
        stack=dbstack('-completenames');
        for i=(1+depth):length(stack)
            fprintf( '  In <a href="matlab: edit %s">%s at line %d</a>\n', stack(i).file, stack(i).name, stack(i).line );
        end
    case 'debug'
        fprintf( '\nCheck failed in: %s\n%s\n', mfilename, message );
        cmd=repmat( 'dbup;', 1, depth );
        fprintf( 'Use the stack to get to <a href="matlab:%s">the place the assertion failed</a> to \n', cmd );
        fprintf( 'investigate the error. Then press F5 to <a href="matlab:dbcont;">continue</a> or <a href="matlab:dbquit;">stop debugging</a>.\n' )
        keyboard;
end

if nargout==0
    clear ok;
end
