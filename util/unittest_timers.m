function unittest_timers
% UNITTEST_TIMERS Test the TIMERS function.
%
% Example (<a href="matlab:run_example unittest_timers">run</a>)
%   unittest_timers
%
% See also TIMERS, TESTSUITE 

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'timers' );

% the following sequence is tested:
% t0, [timer started], t1, [timer stopped], t2==t3, [timer restarted], t4,
% [timer reset], t0==0
timers( 'xx1', 'reset' );
t0=timers( 'xx1', 'get' );
assert_true( 0==t0, 'timer reset', 'reset1' );
timers( 'xx1', 'start' );
t1=timers( 'xx1', 'get' );
assert_true( 0<t1, 'timer running', 'run1' );
timers( 'xx1', 'stop' );
t2=timers( 'xx1', 'get' );
assert_true( t1<t2, 'timer running', 'run2' );
t3=timers( 'xx1', 'get' );
assert_true( t2==t3, 'timer not running', 'not run1' );
timers( 'xx1', 'start' );
t4=timers( 'xx1', 'get' );
assert_true( t3<t4, 'timer running', 'run3' );
timers( 'xx1', 'reset' );
t0=timers( 'xx1', 'get' );
assert_true( 0==t0, 'timer reset', 'reset1' );

% interleave; check that two timers run independently
timers( 'xx1', 'reset' );
timers( 'xx2', 'reset' );
timers( 'xx1', 'start' );
timers( 'xx2', 'start' );
timers( 'xx2', 'stop' );
timers( 'xx1', 'stop' );
t1=timers( 'xx1', 'get' );
t2=timers( 'xx2', 'get' );
assert_true( t1>t2, 't1 runs longer ', 'longer' );
timers( 'xx1', 'start' );
timers( 'xx1', 'stop' );
t3=timers( 'xx1', 'get' );
t4=timers( 'xx2', 'get' );
assert_true( t3>t1, 't1 runs', 't1r' );
assert_true( t4==t2, 't2 stops', 't2s' );
timers( 'xx2', 'start' );
timers( 'xx2', 'stop' );
t5=timers( 'xx1', 'get' );
t6=timers( 'xx2', 'get' );
assert_true( t5==t3, 't1 stops', 't1s' );
assert_true( t6>t4, 't2 runs', 't2r' );

