function test_apply_boundary_conditions
% TEST_APPLY_BOUNDARY_CONDITIONS Test the apply_boundary_conditionsfunction.
%
% Example (<a href="matlab:run_example test_apply_boundary_conditions">run</a>) 
%    test_apply_boundary_conditions
%
% See also APPLY_BOUNDARY_CONDITIONS, TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id: test_stiffness.m 37 2009-04-06 10:02:24Z ezander $ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

assert_set_function( 'apply_boundary_conditions' );

n=7;
K=spdiags( ones(n,1)*[-1,2,-1], [-1,0,1], n, n );
K(1,1)=1;
K(n,n)=1;
bnd=[1,n];
f=(1:n)';
g=((n:-1:1).*(n:-1:1))';

[P_B,P_I]=boundary_projectors( bnd, n );


[Ks,fs]=apply_boundary_conditions( K, f, g, P_B, P_I, 1, 'scaling', .7 );
u=Ks\fs;

assert_equals( P_B*u, P_B*g, 'u_g_B' );
assert_equals( P_I*K*u, P_I*f, 'Ku_f_I' );

