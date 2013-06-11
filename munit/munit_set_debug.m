function old_val=munit_set_debug( bool_val )
% MUNIT_SET_DEBUG Sets debugging in failed assertions on and off.
%   MUNIT_SET_DEBUG( BOOL_VAL ) sets debugging for failed assertions on
%   and off if BOOL_VAL is true or false respectively. If debugging is on
%   ASSERT will call 'keyboard' to allow the user investigate the error.
%
% Example (<a href="matlab:run_example munit_set_debug">run</a>)
%   % turn debugging on
%   munit_set_debug( true );
%
% See also MUNIT_OPTIONS

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

curr_val=munit_options('get', 'debug');

if nargin<1
    bool_val=true;
elseif isempty(bool_val)
    bool_val=false;
elseif islogical(bool_val)
    %noting to do here
elseif isnumeric(bool_val)
    bool_val=(bool_val~=0);
elseif ischar(bool_val)
    switch strtrim( bool_val )
        case { 'true', 'on', 'yes'}
            bool_val=true;
        case { 'false', 'off', 'no' }
            bool_val=false;
        case { 'state' }
            if nargout==0
                on_off={'on','off'};
                fprintf( 'Debugging is turned: %s\n', on_off{2-double(curr_val)} );
            else
                old_val=curr_val;
            end
            return
        otherwise
            error( 'munit_set_debug:bool_val', 'Unknown value for bool_val: %s', bool_val );
    end
else
    error( 'munit_set_debug:bool_val', 'Unknown value for bool_val: %s', evalc( 'disp(bool_val)') );
end

munit_options( 'set', 'debug', bool_val );

if nargout>0
    old_val=curr_val;
end
