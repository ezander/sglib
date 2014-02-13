function unittest_boundary_projectors
% UNITTEST_BOUNDARY_PROJECTORS Test the boundary_projectors function.
%
% Example (<a href="matlab:run_example unittest_boundary_projectors">run</a>)
%    unittest_boundary_projectors
%
% See also BOUNDARY_PROJECTORS, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'boundary_projectors' );
[P_I,P_B]=boundary_projectors( [1,3,5], 8 );

assert_equals( P_B*(1:8)', [1;3;5], 'P_B' );
assert_equals( P_I*(1:8)', [2;4;6;7;8], 'P_I' );

assert_equals( P_B*P_B', eye(3), 'proj_I_B' );
assert_equals( P_I*P_I', eye(5), 'proj_I_I' );
assert_equals( P_B'*P_B+P_I'*P_I, eye(8), 'id' );

I_B=P_B'*P_B;
I_I=P_I'*P_I;
assert_equals( I_B*I_B, I_B, 'proj_B' );
assert_equals( I_I*I_I, I_I, 'proj_I' );
assert_equals( I_I*I_B, zeros(8), 'proj_orth' );
assert_equals( I_I+I_B, eye(8), 'proj_compl' );


n=7;
K=spdiags( ones(n,1)*[-1,2,-1], [-1,0,1], n, n );
K(1,1)=1;
K(n,n)=1;
bnd=[1,n];
f=(1:n)';
g=((n:-1:1).*(n:-1:1))';


% 1. test whether the stuff works on a simple fem problem
% here we combine the operator for the inner and boundary nodes into one
% operator
[P_I,P_B]=boundary_projectors( bnd, n );
I_B=P_B'*P_B;
I_I=P_I'*P_I;

s=0.5;
Ks=I_I*K*I_I+s*I_B;
fs=I_I*(f-K*I_B*g)+s*I_B*g;
u=Ks\fs;

assert_equals( P_B*u, P_B*g, 'u_g_B' );
assert_equals( P_I*K*u, P_I*f, 'Ku_f_I' );


% 2. test whether the stuff works on a simple fem problem
% here we project into the inner nodes, solve for them and assemble back
% the complete solution
[P_I,P_B]=boundary_projectors( bnd, n );

Ki=P_I*K*P_I';
gb=P_B*g;
fi=P_I*(f-K*P_B'*gb);
ui=Ki\fi;
u=P_I'*ui+P_B'*gb;

assert_equals( P_B*u, P_B*g, 'u_gb' );
assert_equals( P_I*K*u, P_I*f, 'Ku_fi' );


