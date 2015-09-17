function munit_printf(type, message, vars)
% MUNIT_PRINTF Prints munit messages.
%   MUNIT_PRINTF(TYPE, MESSAGE, VARS) prints MESSAGE in the command window.
%   Depending on TYPE and the user setting for output messages ('compact',
%   'medium' or 'long'), the current line is first overwritten or not.
%
% Example (<a href="matlab:run_example munit_printf">run</a>)
%
% See also SGLIB_SETTINGS, MUNIT_OPTIONS, MUNIT_PROCESS_ASSERT_RESULTS

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

%options=munit_options();
switch type
    case 'debug'
        debug_mode = munit_set_debug('state');
        no_disp=~debug_mode;
    otherwise
        no_disp=false;
end
if nargin<3
    vars={};
end
compact=munit_options( 'get', 'compact' );

if ~no_disp
    if compact
        erase_print( message, vars{:} );
        newline=true;
        newline=newline & ~(compact>=1 && strcmp(type,'assert_pass'));
        newline=newline & ~(compact>=2 && strcmp(type,'file'));
        if newline
            erase_print();
        end
    else
        message(end+1:end+2)='\n';
        fprintf( message, vars{:} );
    end
end
