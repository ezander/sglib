function unittest_simple_iteration_contractivity
% UNITTEST_SIMPLE_ITERATION_CONTRACTIVITY Test the SIMPLE_ITERATION_CONTRACTIVITY function.
%
% Example (<a href="matlab:run_example unittest_simple_iteration_contractivity">run</a>)
%   unittest_simple_iteration_contractivity
%
% See also SIMPLE_ITERATION_CONTRACTIVITY, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'simple_iteration_contractivity' );

munit_control_rand('seed' );

m=20;
K=matrix_gallery('randcorr',m);
K=K+5*diag(diag(K));
Pinv=diag(1./diag(K));
I=eye(size(K));
x0=rand(m,1);

% the following test only holds because Pinv is some constant times the
% identity matrix and thus Pinv*K is still symmetric
% if Pinv*K is not symmetric normest will give you the largest singular
% value, while contractivity will give you the spectral radius of I-Pinv*K
[rat,flag,iter]=simple_iteration_contractivity( K, Pinv );
assert_equals( rat, normest( I-Pinv*K ), 'contractivity', 'abstol', 1e-3 );
