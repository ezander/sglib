function unittest_apply_boundary_conditions
% UNITTEST_APPLY_BOUNDARY_CONDITIONS Test the APPLY_BOUNDARY_CONDITIONS function.
%
% Example (<a href="matlab:run_example unittest_apply_boundary_conditions">run</a>)
%    unittest_apply_boundary_conditions
%
% See also APPLY_BOUNDARY_CONDITIONS, TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'apply_boundary_conditions' );



n=7;
K=spdiags( ones(n,1)*[-1,2,-1], [-1,0,1], n, n );
K(1,1)=1;
K(n,n)=1;
bnd=[1,n];
f=(1:n)';
g=((n:-1:1).*(n:-1:1))';

[P_I,P_B]=boundary_projectors( bnd, n );


Ki=apply_boundary_conditions_operator( K, P_I );
fi=apply_boundary_conditions_rhs( K, f, g, P_I, P_B );
ui=Ki\fi;
u=apply_boundary_conditions_solution( ui, g, P_I, P_B );

u2=P_I'*ui+P_B'*P_B*g;

assert_equals( u, u2, 'u' );
assert_equals( P_B*u, P_B*g, 'u_g_B' );
assert_equals( P_I*K*u, P_I*f, 'Ku_f_I' );
