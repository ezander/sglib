function unittest_estimate_rate
% UNITTEST_ESTIMATE_RATE Test the ESTIMATE_RATE function.
%
% Example (<a href="matlab:run_example unittest_estimate_rate">run</a>)
%   unittest_estimate_rate
%
% See also ESTIMATE_RATE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'estimate_rate' );

N=logspace2( 10, 1000, 20 );
T=round(N).^3.5;

[p,T2,N2]=estimate_rate( @(x)(x), N, 'T', T, 'doplot', false );

assert_equals( p, 3.5, 'p' );
assert_equals( N2, round(N), 'N' );
assert_equals( T2, T, 'T' );


