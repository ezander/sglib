function unittest_ctensor_rank
% UNITTEST_CTENSOR_RANK Test the CTENSOR_RANK function.
%
% Example (<a href="matlab:run_example unittest_ctensor_rank">run</a>)
%   unittest_ctensor_rank
%
% See also CTENSOR_RANK, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'ctensor_rank' );

assert_equals( ctensor_rank({zeros(10,4), zeros(10,4), zeros(12,4)}), 4, 'full' );

assert_error( 'ctensor_rank(rand(3,4))', 'tensor:param', 'param' );
assert_error( 'ctensor_rank(''dummy'')', 'tensor:param', 'wrong_arg' );
