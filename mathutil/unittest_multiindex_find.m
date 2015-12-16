function unittest_multiindex_find
% UNITTEST_MULTIINDEX_FIND Test the MULTIINDEX_FIND function.
%
% Example (<a href="matlab:run_example unittest_multiindex_find">run</a>)
%    unittest_multiindex_find
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'multiindex_find' );

I=multiindex(5,3);

alpha=[0 0 0 0 0];
ind=multiindex_find( alpha, I );
assert_equals( ind, 1, 'zero_ind');
assert_equals( I(ind,:), alpha, 'zero_eq' );

alpha=[0 1 0 0 2];
ind=multiindex_find( alpha, I );
assert_equals( I(ind,:), alpha, 'eq' );

alpha=[0 0 0 0 0; 0 1 0 0 2];
ind=multiindex_find( alpha, I );
assert_equals( I(ind,:), alpha, 'multi' );

I=[0;4;3;1;2];
alpha=[0;1;2;3];
ind=multiindex_find( alpha, I );
assert_equals( ind, [1;4;5;3], 'multi2' );


I_a=[6;5;4;3;2];
I_b=[0;1;2;3];
ind_b=multiindex_find( I_a, I_b );
assert_equals( ind_b, [0;0;0;4;3], 'disj1' );
[ind_b,ind_a]=multiindex_find( I_a, I_b );
assert_equals( ind_a, [4;5], 'disj2' );
assert_equals( ind_b, [4;3], 'disj3' );
assert_equals( I_a(ind_a,:), I_b(ind_b,:), 'disj4' );


%% As operators
I_a=[0;1;2;3];
I_b=[6;1;5;4;0;3;2];
Pr_ab=multiindex_find( I_a, I_b, 'as_operators', true);

a_i_alpha = rand(2, size(I_a,1));
a_i_beta = a_i_alpha * Pr_ab;
[ma,va] = pce_moments(a_i_alpha, I_a);
[mb,vb] = pce_moments(a_i_beta, I_b);
assert_equals(mb, ma, 'mean_proj_pce');
assert_equals(vb, va, 'var_proj_pce');

[Pr_ab, Pr_ba]=multiindex_find( I_a, I_b, 'as_operators', true);
assert_equals(full(Pr_ab*Pr_ba), eye(size(I_a,1)), 'pr_rest_is_id');
