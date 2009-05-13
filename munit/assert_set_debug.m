function assert_set_debug( bool_val )
% ASSERT_SET_DEBUG Sets debugging in failed assertions on and off.
%   ASSERT_SET_DEBUG( BOOL_VAL ) sets debugging for failed assertions on
%   and off if BOOL_VAL is true or false respectively. If debugging is on
%   ASSERT will call 'keyboard' to allow the user investigate the error.
%
% Example (<a href="matlab:run_example assert_set_debug">run</a>)
%   % turn debugging on
%   assert_set_debug( true );
%
% See also ASSERT

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin<1
    options.debug=true;
else
    options.debug=bool_val;
end
assert_set_option( options );
