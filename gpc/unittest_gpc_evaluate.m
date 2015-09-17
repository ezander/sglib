function unittest_gpc_evaluate
% UNITTEST_GPC_EVALUATE Test the GPC_EVALUATE function.
%
% Example (<a href="matlab:run_example unittest_gpc_evaluate">run</a>)
%   unittest_gpc_evaluate
%
% See also GPC_EVALUATE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpc_evaluate' );

% Test with monomials
% m=1
p = 5;
m = 1;
I_a = multiindex(m, p);
M=size(I_a,1);
a_i_alpha = eye(M);

xi = rand(m, 20);
a=gpc_evaluate(a_i_alpha, {'M', I_a}, xi);
assert_equals(a, binfun(@power, xi, I_a), 'mono1')

%m>1
p = 5;
m = 2;
I_a = multiindex(m, p);
M=size(I_a,1);
a_i_alpha = eye(M);

xi = rand(m, 20);
a=gpc_evaluate(a_i_alpha, {'M', I_a}, xi);
assert_equals(a, ...
    binfun(@power, xi(1,:), I_a(:,1)) .* ...
    binfun(@power, xi(2,:), I_a(:,2)), 'mono2')

% Test orthogonality
N = 5;
I_a = multiindex(1, N);
a_i_alpha = eye(N+1);

% ... for Hermite
[xi, w] = gauss_hermite_rule(N+1);
a=gpc_evaluate(a_i_alpha, {'H', I_a}, xi);
D = a * diag(w) * a';
assert_matrix(D, 'diagonal', 'H_ortho')

a=gpc_evaluate(a_i_alpha, {'h', I_a}, xi);
D = a * diag(w) * a';
assert_matrix(D, 'identity', 'h_orthonormal')

% ... for Legendre

[xi, w] = gauss_legendre_rule(N+1);
w = 0.5 * w;

a=gpc_evaluate(a_i_alpha, {'P', I_a}, xi);
D = a * diag(w) * a';
assert_matrix(D, 'diagonal', 'P_ortho')

a=gpc_evaluate(a_i_alpha, {'p', I_a}, xi);
D = a * diag(w) * a';
assert_matrix(D, 'identity', 'p_orthonormal')


% Test one precomputed example
I_a=multiindex( 2, 3 );
a_i_alpha=cumsum(ones( 5, 10 ));
xi=reshape( linspace( -1, 1, 14 ), 2, [] );

expect=[
   3.93263541192535   2.88757396449704   1.01228948566227  -0.99408284023669  -2.43240782885753  -2.60355029585799  -0.80837505689577
   7.86527082385071   5.77514792899408   2.02457897132453  -1.98816568047337  -4.86481565771507  -5.20710059171598  -1.61675011379153
  11.79790623577606   8.66272189349112   3.03686845698680  -2.98224852071006  -7.29722348657260  -7.81065088757396  -2.42512517068730
  15.73054164770141  11.55029585798816   4.04915794264907  -3.97633136094675  -9.72963131543013 -10.41420118343195  -3.23350022758306
  19.66317705962676  14.43786982248521   5.06144742831133  -4.97041420118343 -12.16203914428766 -13.01775147928994  -4.04187528447883];
actual=gpc_evaluate( a_i_alpha, {'H', I_a}, xi );
assert_equals( actual, expect, 'H_val' );


% Test one non-mixed example with Legendre
I_a=multiindex( 2, 3 );
a_i_alpha=eye(size(I_a,1));
V_a = {'P', I_a};
xi=gpcgerm_sample(V_a, 7);
a12 = gpc_evaluate(a_i_alpha, V_a, xi);
a1 = gpc_evaluate(a_i_alpha, {'P', I_a(:,1)}, xi(1,:));
a2 = gpc_evaluate(a_i_alpha, {'P', I_a(:,2)}, xi(2,:));
assert_equals(a12, a1 .* a2, 'non-mixed');

% Test one mixed example with Legendre and Hermite
I_a=multiindex( 2, 3 );
a_i_alpha=eye(size(I_a,1));
V_a = {'hp', I_a};
xi=gpcgerm_sample(V_a, 7);
a12 = gpc_evaluate(a_i_alpha, V_a, xi);
a1 = gpc_evaluate(a_i_alpha, {'h', I_a(:,1)}, xi(1,:));
a2 = gpc_evaluate(a_i_alpha, {'p', I_a(:,2)}, xi(2,:));
assert_equals(a12, a1 .* a2, 'mixed');

