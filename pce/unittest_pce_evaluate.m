function unittest_pce_evaluate
% UNITTEST_PCE_EVALUATE Test the PCE_EVALUATE function.
%
% Example (<a href="matlab:run_example unittest_pce_evaluate">run</a>)
%   unittest_pce_evaluate
%
% See also PCE_EVALUATE, MUNIT_RUN_TESTSUITE 

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

I_a=multiindex( 2, 3 );
a_i_alpha=cumsum(ones( 5, 10 ));
xi=reshape( linspace( -1, 1, 14 ), 2, [] );

expect=[
   3.93263541192535   2.88757396449704   1.01228948566227  -0.99408284023669  -2.43240782885753  -2.60355029585799  -0.80837505689577
   7.86527082385071   5.77514792899408   2.02457897132453  -1.98816568047337  -4.86481565771507  -5.20710059171598  -1.61675011379153
  11.79790623577606   8.66272189349112   3.03686845698680  -2.98224852071006  -7.29722348657260  -7.81065088757396  -2.42512517068730
  15.73054164770141  11.55029585798816   4.04915794264907  -3.97633136094675  -9.72963131543013 -10.41420118343195  -3.23350022758306
  19.66317705962676  14.43786982248521   5.06144742831133  -4.97041420118343 -12.16203914428766 -13.01775147928994  -4.04187528447883];
actual=pce_evaluate( a_i_alpha, I_a, xi );
assert_equals( actual, expect, '' );
