function unittest_simple_iteration_normest
% UNITTEST_SIMPLE_ITERATION_NORMEST Test the SIMPLE_ITERATION_NORMEST function.
%
% Example (<a href="matlab:run_example unittest_simple_iteration_normest">run</a>)
%   unittest_simple_iteration_normest
%
% See also SIMPLE_ITERATION_NORMEST, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'simple_iteration_normest' );

rand( 'seed', 754762 );
randn( 'seed', 754762 );

m=20;
K=matrix_gallery('randcorr',m);
K=K+5*diag(diag(K));
Pinv=diag(1./diag(K));
I=eye(size(K));
x0=rand(m,1);

[rat,flag,iter]=simple_iteration_normest( K, Pinv, x0 )
assert_equals( rat, normest( I-Pinv*K ), 'normest', 'abstol', 2e-4 );
