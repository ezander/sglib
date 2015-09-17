function unittest_timers
% UNITTEST_TIMERS Test the TIMERS function.
%
% Example (<a href="matlab:run_example unittest_timers">run</a>)
%   unittest_timers
%
% See also TIMERS, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing
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
timers( 'reset', 'xx1' );
t0=timers( 'get', 'xx1' );
assert_true( 0==t0, 'timer reset', 'reset1' );
timers( 'start', 'xx1' );
t1=timers( 'get', 'xx1' );
assert_true( 0<t1, 'timer running', 'run1' );
timers( 'stop', 'xx1' );
t2=timers( 'get', 'xx1' );
assert_true( t1<t2, 'timer running', 'run2' );
t3=timers( 'get', 'xx1' );
assert_true( t2==t3, 'timer not running', 'not run1' );
timers( 'start', 'xx1' );
t4=timers( 'get', 'xx1' );
assert_true( t3<t4, 'timer running', 'run3' );
timers( 'reset', 'xx1' );
t0=timers( 'get', 'xx1' );
assert_true( 0==t0, 'timer reset', 'reset1' );


% interleave; check that two timers run independently
timers( 'reset', 'xx1' );
timers( 'reset', 'xx2' );
timers( 'start', 'xx1' );
timers( 'start', 'xx2' );
timers( 'stop', 'xx2' );
timers( 'stop', 'xx1' );
t1=timers( 'get', 'xx1' );
t2=timers( 'get', 'xx2' );
assert_true( t1>t2, 't1 runs longer ', 'longer' );
timers( 'start', 'xx1' );
timers( 'stop', 'xx1' );
t3=timers( 'get', 'xx1' );
t4=timers( 'get', 'xx2' );
assert_true( t3>t1, 't1 runs', 't1r' );
assert_true( t4==t2, 't2 stops', 't2s' );
timers( 'start', 'xx2' );
timers( 'stop', 'xx2' );
t5=timers( 'get', 'xx1' );
t6=timers( 'get', 'xx2' );
assert_true( t5==t3, 't1 stops', 't1s' );
assert_true( t6>t4, 't2 runs', 't2r' );

% multiple starting and stopping
timers( 'reset', 'xx1' );
timers( 'start', 'xx1' );
timers( 'start', 'xx1' );
timers( 'stop', 'xx1' );
t1=timers( 'get', 'xx1' );
timers( 'stop', 'xx1' );
t2=timers( 'get', 'xx1' );
t3=timers( 'get', 'xx1' );
assert_true( t2>t1, 'still running', 'stillrun1' );
assert_true( t3==t2, 'not running', 'notrun1' );

% multiple starting and stopping
k=1.00;
t1=k*0.23; t2=k*0.05; tw=k*0.1;
timers( 'reset', 'xx1' );
timers( 'start', 'xx1' );
t=tic; while toc(t)<t1; end
timers( 'stop', 'xx1' );
t=tic; while toc(t)<tw; end
timers( 'start', 'xx1' );
t=tic; while toc(t)<t2; end
timers( 'start', 'xx1' );
ts=timers( 'get', 'xx1' );
assert_equals( ts, t1+t2, 'exact', 'abstol', 0.003 );

