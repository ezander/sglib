function munit_set_function( fun_name )
% MUNIT_SET_FUNCTION Sets the function name for the following assertions.
%   MUNIT_SET_FUNCTION( FUN_NAME ) sets the function name to FUN_NAME for
%   the following assertions. FUN_NAME can also be empty in which case the
%   function name is determined via the stack contents, removing any
%   "unittest_" prefix from the function name.
%
% Example (<a href="matlab:run_example munit_set_function">run</a>)
%   % maybe in some function 'unittest_all_of_my_methods'
%   munit_set_function( 'my_function' );
%
%   % in a function 'unittest_my_function' this will also do
%   munit_set_function();
%
% See also MUNIT_STATS, MUNIT_OPTIONS

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


if nargin<1 || isempty(fun_name)
    frame=dbstack;
    prefix=munit_options('get','prefix');
    fun_name='';
    for i=2:length(frame)
        curr_name=frame(i).name;
        if strncmp( curr_name, prefix, length(prefix) )
            fun_name=curr_name( length(prefix)+1:end );
            break;
        end
    end
    if isempty(fun_name)
        warning('sglib:munit', 'could not determine function name from stack');
        fun_name='<unknown>';
    end
end
munit_stats( 'set', 'function_name', fun_name);
