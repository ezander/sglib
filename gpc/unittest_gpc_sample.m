function unittest_gpc_sample(varargin)
% UNITTEST_GPC_SAMPLE Test the GPC_SAMPLE function.
%
% Example (<a href="matlab:run_example unittest_gpc_sample">run</a>)
%   unittest_gpc_sample
%
% See also GPC_SAMPLE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpc_sample' );

V_r = gpcbasis_create('PP', 'I', [0 0; 1 0; 2 0; 0 1; 0 2; 0 3]);
r_i_alpha = [0.5, 0, 1, 0, 0, 0; 0, 0, 0, 1.5, 0, 1];
r_i_j = gpc_sample(r_i_alpha, V_r, 314, 'mode', 'qmc');

assert_equals(size(r_i_j), [2, 314], 'size');
assert_true(all(r_i_j(1,:)>=0 & r_i_j(1,:)<=1.5 & ...
    r_i_j(2,:)>=-2.5 & r_i_j(2,:)<=2.5), 'range');
