function assert_set_function( fun_name )
% ASSERT_SET_FUNCTION Sets the function name for the following assertions.
%   ASSERT_SET_FUNCTION( FUN_NAME ) sets the function name to FUN_NAME for
%   the following assertions. FUN_NAME can also be empty in which case the
%   function name is determined via the stack contents, removing any
%   "unittest_" prefix from the function name.
%
% Example (<a href="matlab:run_example assert_set_function">run</a>)
%   % maybe in some function 'unittest_all_of_my_methods'
%   assert_set_function( 'my_function' );
%
%   % in a function 'unittest_my_function' this will also do
%   assert_set_function();
%
% See also ASSERT, ASSERT_SET_MODULE

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


if nargin<1 || isempty(fun_name)
    frame=dbstack;
    if length(frame)>=2
        fun_name=frame(2).name;
        if strncmp( fun_name, 'unittest_', 5 )
            fun_name=fun_name( 6:end );
        end
    else
        warning('could not determine function name from stack'); %#ok
        fun_name='<unknown>';
    end
end
options.function_name=fun_name;
assert_set_option( options );
