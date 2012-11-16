function unittest_polysys_recur_coeff
% UNITTEST_POLYSYS_RECUR_COEFF Test the POLYSYS_RECUR_COEFF function.
%
% Example (<a href="matlab:run_example unittest_polysys_recur_coeff">run</a>)
%   unittest_polysys_recur_coeff
%
% See also POLYSYS_RECUR_COEFF, TESTSUITE 

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'polysys_recur_coeff' );

% Hermite
assert_equals(polysys_recur_coeff('H', 5), ...
    [[0,1,0]; [0,1,1]; [0,1,2]; [0,1,3]; [0,1,4]],'H');

assert_equals(polysys_recur_coeff('h', 5), ...
    sqrt([[0,1,0]/1;
          [0,1,1]/2;
          [0,1,2]/3;
          [0,1,3]/4;
          [0,1,4]/5]), 'h')

% Legendre
assert_equals(polysys_recur_coeff('P', 5), ...
    [[0,1,0]; [0,3,1]/2; [0,5,2]/3; [0,7,3]/4; [0,9,4]/5],'P');


