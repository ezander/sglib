function unittest_gpc_sample
% UNITTEST_GPC_SAMPLE Test the GPC_SAMPLE function.
%
% Example (<a href="matlab:run_example unittest_gpc_sample">run</a>)
%   unittest_gpc_sample
%
% See also GPC_SAMPLE, TESTSUITE 

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

munit_set_function( 'gpc_sample' );

I = multiindex(3,2);

xi = gpc_sample({'H', I}, 500);
assert_equals(size(xi), [3, 500], 'size1');
assert_equals(any(xi(:)>1), true, 'normal any>1', {'fuzzy', true});

xi = gpc_sample({'H', I});
assert_equals(size(xi), [3, 1], 'default_size');

xi = gpc_sample({'P', I}, 500);
assert_equals(size(xi), [3, 500], 'size2');
assert_equals(all(xi(:)<1), true, 'uniform all<1', {'fuzzy', true});

xi = gpc_sample({'PHp', I}, 1500);
assert_equals(size(xi), [3, 1500], 'size3');
assert_equals(all(xi(1,:)<1), true, 'xi1<1', {'fuzzy', true});
assert_equals(any(xi(2,:)>1), true, 'xi2>1', {'fuzzy', true});
assert_equals(all(xi(3,:)<1), true, 'xi2<1', {'fuzzy', true});


%%
m=3; N=347;
I = multiindex(m,2);
V = {'PHp', I};
assert_equals(size(gpc_sample(V, N, 'mode', 'default')), [m, N], 'size1_def');
assert_equals(size(gpc_sample(V, N, 'mode', 'lhs')), [m, N], 'size1_lhs');
assert_equals(size(gpc_sample(V, N, 'mode', 'qmc')), [m, N], 'size1_qmc');

V = {'P', I};
assert_equals(size(gpc_sample(V, N, 'mode', 'default')), [m, N], 'size2_def');
assert_equals(size(gpc_sample(V, N, 'mode', 'lhs')), [m, N], 'size2_lhs');
assert_equals(size(gpc_sample(V, N, 'mode', 'qmc')), [m, N], 'size2_qmc');

%% qmc is repeatable
assert_equals(gpc_sample(V, N, 'mode', 'qmc'), gpc_sample(V, N, 'mode', 'qmc'), 'rep_qmc');
