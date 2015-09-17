function unittest_accsum
% UNITTEST_ACCSUM Test the ACCSUM function.
%
% Example (<a href="matlab:run_example unittest_accsum">run</a>)
%   unittest_accsum
%
% See also ACCSUM, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'accsum' );

% first some really really trivial tests which should however work
assert_equals( accsum([]), 0, 'zero' );
assert_equals( accsum(12), 12, 'one' );

% simple summation
assert_equals( accsum(1:5), 15, 'easy' );

% medium (Kahan would work here already)
d=eps/2;
a=[1 d d d d -1];
assert_equals( accsum(a), 2*eps, 'medium' );

% harder (Kahan would not work here anymore)
vals = [7.0, 1e100, -7.0, -1e100, -9e-20, 8e-20];
vals= repmat( vals, 1, 10 );
assert_equals( accsum(vals), -1e-19, 'hard' );

