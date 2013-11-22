function unittest_compute_pce_rhs
% UNITTEST_COMPUTE_PCE_RHS Test the COMPUTE_PCE_RHS function.
%
% Example (<a href="matlab:run_example unittest_compute_pce_rhs">run</a>)
%   unittest_compute_pce_rhs
%
% See also COMPUTE_PCE_RHS 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

I_a=[0 0; 1 0; 0 2; 3 4];
I_b=[3 4; 0 0; 0 2; 1 0; 4 4];

a_alpha=[1 2 3 4];
expected=[1*1*1, 1*1*2, 1*2*3, 6*24*4 ];
actual=compute_pce_rhs( a_alpha, I_a );
assert_equals( actual, expected, 'defarg' );

actual=compute_pce_rhs( a_alpha, I_a, I_a );
assert_equals( actual, expected, 'same' );

expected=[6*24*4, 1*1*1, 1*2*3, 1*1*2, 24*24*0 ];
actual=compute_pce_rhs( a_alpha, I_a, I_b );
assert_equals( actual, expected, 'single' );

a_alpha=[a_alpha; 5 6 7 8];
expected=[expected; 6*24*8, 1*1*5, 1*2*7, 1*1*6, 24*24*0 ];
actual=compute_pce_rhs( a_alpha, I_a, I_b );
assert_equals( actual, expected, 'mult' );

% non existing indices
I_a=[0 0; 1 0; 0 2; 3 4];
I_b=[5 5; 0 0; 0 2; 6 6; 6 6];

a_alpha=[1 2 3 4];
expected=[0, 1, 2*3, 0, 0 ];
actual=compute_pce_rhs( a_alpha, I_a, I_b );
assert_equals( actual, expected, 'defarg' );
