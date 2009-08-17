function assert_print_module_stats
% ASSERT_PRINT_MODULE_STATS Print the statistics of the current module.
%   ASSERT_PRINT_MODULE_STATS print the statistics of the current module on
%   the console.
%
% Example (<a href="matlab:run_example assert_print_module_stats">run</a>)
%   assert_set_module( 'mymod' );
%   assert_equals( myfunc, 3, 'some_test' );
%   assert_print_module_stats();
%
% See also ASSERT, ASSERT_EQUALS, ASSERT_SET_MODULE

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


[stats,options]=assert();
output_func=options.output_func;

msg=sprintf( 'Module "%s": %d of %d assertions failed.', ...
    options.module_name, stats.assertion_failed_module, ...
    stats.assertion_total_module );
output_func( msg );
if stats.assertion_failed_poss_module>0
    msg=sprintf( '%d (fuzzy) assertions possibly failed', ...
        stats.assertion_failed_poss_module );
    if stats.assertion_failed_module>0
        output_func( [msg ', too.'] );
    else
        output_func( [msg '.'] );
    end
end
