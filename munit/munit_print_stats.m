function munit_print_stats
% MUNIT_PRINT_STATS Print the statistics of the current module.
%   MUNIT_PRINT_STATS print the statistics of the current module on
%   the console.
%
% Example (<a href="matlab:run_example munit_print_stats">run</a>)
%   assert_set_module( 'mymod' );
%   assert_equals( myfunc, 3, 'some_test' );
%   munit_print_stats();
%
% See also MUNIT_STATS

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


stats=munit_stats('get');

munit_printf( 'stats', ...
    'Module "%s": %d of %d assertions failed.', ...
    {stats.total_module_name, stats.assertions_failed, stats.total_assertions_module} );
%    {stats.module_name, stats.assertions_failed, stats.total_assertions} );

if stats.assertions_failed_poss>0
    if stats.assertions_failed>0
        ending=', too';
    else
        ending='';
    end
    munit_printf( 'stats',...
        '%d (fuzzy) assertions possibly failed%s.', ...
        {stats.assertions_failed_poss, ending} );
end
