function unittest_lbfgs_solve
% UNITTEST_LBFGS_SOLVE Test the LBFGS_SOLVE function.
%
% Example (<a href="matlab:run_example unittest_lbfgs_solve">run</a>)
%   unittest_lbfgs_solve
%
% See also LBFGS_SOLVE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'lbfgs_solve' );

A = rand(10);
H0 = A*A';
b = rand(10,1);

H = H0;
Y={};
S={};
for i=1:4
    x1 = H*b;
    x2 = lbfgs_solve(H0, Y, S, b);
    assert_equals(x1, x2);

    y = rand(10,1);
    s = rand(10,1);
    [~,H]=qn_matrix_update('bfgs', [], H, y, s);
    Y = [Y, y]; %#ok<AGROW>
    S = [S, s]; %#ok<AGROW>
end

