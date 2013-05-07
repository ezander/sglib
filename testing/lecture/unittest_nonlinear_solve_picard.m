function unittest_nonlinear_solve_picard
% UNITTEST_NONLINEAR_SOLVE_PICARD Test the NONLINEAR_SOLVE_PICARD function.
%
% Example (<a href="matlab:run_example unittest_nonlinear_solve_picard">run</a>)
%   unittest_nonlinear_solve_picard
%
% See also NONLINEAR_SOLVE_PICARD, TESTSUITE 

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'nonlinear_solve_picard' );

% function to solve, find sqrt(p)
f = @(state,x,p)(x^2-p);
df = @(state,x,p)(2*x);
res = @(state,x,p)(-df(state,x,p)\f(state,x,p));
state = struct('u0', 1);
state.A = 1;
[u, iter, res] = nonlinear_solve_picard(res, state, 3, 'verbose', false);
assert_equals(u, sqrt(3), 'sqrt3');

% function to solve A*x 
f = @(state,x,p)(state.A*x + (x'*x)*x);
res = @(state,x,p)(state.b - f(state,x,p));

% picard iterations are pretty sensitive so we need to set the random
% matrix to a specific one
rand('seed', 1234); 
n = 5;
L = rand(5);
A = 200*L'*L;
u_ex = rand(n, 1);

state = struct();
state.u0 = zeros(n,1);
state.A = A; 
state.b = funcall(f, state, u_ex, []);

[u, iter, res] = nonlinear_solve_picard(res, state, [], 'verbose', false, 'abstol', 1e-8);
assert_equals(u, u_ex, 'nonlin_system');
assert_true(res<1e-8, [], 'nonlin_system_res');

