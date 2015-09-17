function unittest_get_stoch_size
% UNITTEST_GET_STOCH_SIZE Test the GET_STOCH_SIZE function.
%
% Example (<a href="matlab:run_example unittest_get_stoch_size">run</a>)
%   unittest_get_stoch_size
%
% See also GET_STOCH_SIZE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'get_stoch_size' );

N = 20;
NI = 13;
M = 17;

K = zeros(N*M, N*M);
u = zeros(N, M);
u_I = zeros(NI, M);
P_I = zeros(NI, N);

assert_equals(get_stoch_size(P_I, K, [], []), M, 'from_K');
assert_equals(get_stoch_size(P_I, [], u_I, []), M, 'from_u_I');
assert_equals(get_stoch_size(P_I, [], [], u), M, 'from_u');

assert_error(funcreate(@get_stoch_size, P_I, [], [], []), 'sglib:', 'err_none');
assert_error(funcreate(@get_stoch_size, P_I, [], u_I, u), 'sglib:', 'err_two');
assert_error(funcreate(@get_stoch_size, P_I, [], u, []), 'sglib:', 'err_wrong');

