function unittest_pce_normalize
% UNITTEST_PCE_NORMALIZE Test the PCE_NORMALIZE function.
%
% Example (<a href="matlab:run_example unittest_pce_normalize">run</a>)
%    unittest_pce_normalize
%
% See also PCE_NORMALIZE, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'pce_normalize' );


I_a=[0 0; 1 1; 2 2; 3 3];
a_i_alpha=[1 2 3 4; 5 6 7 8];
b_i_alpha=pce_normalize( a_i_alpha, I_a );
assert_equals( b_i_alpha, [1 2 6 24; 5 6 14 48], 'direct' );

[a_i_alpha,I_a]=pce_expand_1d( @exp, 7 );

b_i_alpha=pce_normalize( a_i_alpha, I_a );
assert_equals( b_i_alpha, a_i_alpha.*sqrt(factorial(0:7)), 'normed' );

b_i_alpha=pce_normalize( a_i_alpha, I_a, false );
assert_equals( b_i_alpha, a_i_alpha.*sqrt(factorial(0:7)), 'normed' );

a2_i_alpha=pce_normalize( b_i_alpha, I_a, true );
assert_equals( a2_i_alpha, a_i_alpha, 'unnormed' );
