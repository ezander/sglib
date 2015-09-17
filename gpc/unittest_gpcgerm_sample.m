function unittest_gpcgerm_sample
% UNITTEST_GPCGERM_SAMPLE Test the GPCGERM_SAMPLE function.
%
% Example (<a href="matlab:run_example unittest_gpcgerm_sample">run</a>)
%   unittest_gpcgerm_sample
%
% See also GPCGERM_SAMPLE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpcgerm_sample' );

I = multiindex(3,2);

xi = gpcgerm_sample({'H', I}, 500);
assert_equals(size(xi), [3, 500], 'size1');
assert_equals(any(xi(:)>1), true, 'normal any>1', {'fuzzy', true});

xi = gpcgerm_sample({'H', I});
assert_equals(size(xi), [3, 1], 'default_size');

xi = gpcgerm_sample({'P', I}, 500);
assert_equals(size(xi), [3, 500], 'size2');
assert_equals(all(xi(:)<1), true, 'uniform all<1', {'fuzzy', true});

xi = gpcgerm_sample({'PHp', I}, 1500);
assert_equals(size(xi), [3, 1500], 'size3');
assert_equals(all(xi(1,:)<1), true, 'xi1<1', {'fuzzy', true});
assert_equals(any(xi(2,:)>1), true, 'xi2>1', {'fuzzy', true});
assert_equals(all(xi(3,:)<1), true, 'xi2<1', {'fuzzy', true});


%%
m=3; N=347;
I = multiindex(m,2);
V = {'PHp', I};
assert_equals(size(gpcgerm_sample(V, N, 'mode', 'default')), [m, N], 'size1_def');
assert_equals(size(gpcgerm_sample(V, N, 'mode', 'lhs')), [m, N], 'size1_lhs');
assert_equals(size(gpcgerm_sample(V, N, 'mode', 'qmc')), [m, N], 'size1_qmc');

V = {'P', I};
assert_equals(size(gpcgerm_sample(V, N, 'mode', 'default')), [m, N], 'size2_def');
assert_equals(size(gpcgerm_sample(V, N, 'mode', 'lhs')), [m, N], 'size2_lhs');
assert_equals(size(gpcgerm_sample(V, N, 'mode', 'qmc')), [m, N], 'size2_qmc');

%% qmc is repeatable
assert_equals(gpcgerm_sample(V, N, 'mode', 'qmc'), gpcgerm_sample(V, N, 'mode', 'qmc'), 'rep_qmc');

%% test with rand_func functions
assert_equals(gpcgerm_sample(gpcbasis_create('ppp'), 7, 'rand_func', @ones), ones(3, 7), 'rfunc_ones');
assert_equals(gpcgerm_sample(gpcbasis_create('ppp'), 7, 'rand_func', @zeros), -ones(3, 7), 'rfunc_zeros1');
assert_equals(gpcgerm_sample(gpcbasis_create('lll'), 7, 'rand_func', @zeros), -zeros(3, 7), 'rfunc_zeros2');
assert_equals(gpcgerm_sample(gpcbasis_create('ut'), 7, 'rand_func', @zeros), -ones(2, 7), 'rfunc_zeros3');

assert_equals(gpcgerm_sample(gpcbasis_create('hpuHPT'), 7, 'rand_func', @half), zeros(6, 7), 'rfunc_half1');
assert_error(funcreate(@gpcgerm_sample, gpcbasis_create('h', 'm', 3), 7, 'rand_func', @wrong), 'sglib:gpcgerm_sample', 'err_nomatch');

function U=half(n,m)
U=0.5 + zeros(n,m);

function U=wrong(n,m)
U=zeros(n+2,m);
