function unittest_gpcbasis_combine(varargin)
% UNITTEST_GPCBASIS_COMBINE Test the GPCBASIS_COMBINE function.
%
% Example (<a href="matlab:run_example unittest_gpcbasis_combine">run</a>)
%   unittest_gpcbasis_combine
%
% See also GPCBASIS_COMBINE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpcbasis_combine' );


V_h23 = gpcbasis_create('h', 'm', 2, 'p', 3);
V_h24 = gpcbasis_create('h', 'm', 2, 'p', 4);
V_l34 = gpcbasis_create('l', 'm', 3, 'p', 4);
V_hlp = gpcbasis_create('hlp', 'p', 3);
V_hh = gpcbasis_create('hh', 'p', 3);
V_M23 = gpcbasis_create('M', 'm', 2, 'p', 3);
V_M24 = gpcbasis_create('M', 'm', 2, 'p', 4);


%% Outer sum
V1 = V_h23;
V2 = V_l34;
M1 = gpcbasis_size(V1,1);
M2 = gpcbasis_size(V2,1);
[V, ind_phi1, ind_phi2, ind_xi1, ind_xi2]=gpcbasis_combine(V1, V2, 'outer_sum');
assert_equals(V{1}, 'hhlll'); % 'h' would be ok, too
assert_equals(gpcbasis_size(V,1), M1+M2-1);
assert_equals(ind_xi1, [1, 2]);
assert_equals(ind_xi2, [3, 4, 5]);
assert_equals(V{2}(ind_phi1, ind_xi1), V1{2})
assert_equals(V{2}(ind_phi2, ind_xi2), V2{2})

a1 = gpc_rand_coeffs(V1, 1);
a2 = gpc_rand_coeffs(V2, 1);
xi = gpcgerm_sample(V, 3);
a = zeros(1, gpcbasis_size(V, 1));
a(ind_phi1) = a1;
a(ind_phi2) = a(ind_phi2) + a2;
assert_equals(gpc_evaluate(a, V, xi), gpc_evaluate(a1, V1, xi(ind_xi1,:))+...
gpc_evaluate(a2, V2, xi(ind_xi2,:)))



%% Inner sum
V1 = V_h23;
V2 = V_h24;
M1 = gpcbasis_size(V1,1);
M2 = gpcbasis_size(V2,1);
[V, ind_phi1, ind_phi2, ind_xi1, ind_xi2]=gpcbasis_combine(V1, V2, 'inner_sum');
assert_equals(V{1}, 'h'); % 'hh' would be ok, too
assert_equals(gpcbasis_size(V,1), max(M1,M2));
assert_equals(ind_xi1, [1, 2]);
assert_equals(ind_xi2, [1, 2]);
assert_equals(V{2}(ind_phi1, ind_xi1), V1{2})
assert_equals(V{2}(ind_phi2, ind_xi2), V2{2})

a1 = gpc_rand_coeffs(V1, 1);
a2 = gpc_rand_coeffs(V2, 1);
xi = gpcgerm_sample(V, 3);
a = zeros(1, gpcbasis_size(V, 1));
a(ind_phi1) = a1;
a(ind_phi2) = a(ind_phi2) + a2;
assert_equals(gpc_evaluate(a, V, xi), gpc_evaluate(a1, V1, xi(ind_xi1,:))+...
gpc_evaluate(a2, V2, xi(ind_xi2,:)))




%% Outer product 
V1 = V_h23;
V2 = V_l34;
M1 = gpcbasis_size(V1,1);
M2 = gpcbasis_size(V2,1);
[V, ind_phi1, ind_phi2, ind_xi1, ind_xi2]=gpcbasis_combine(V1, V2, 'outer_product');
assert_equals(V{1}, 'hhlll'); % 'h' would be ok, too
assert_equals(gpcbasis_size(V,1), M1*M2);
assert_equals(ind_xi1, [1, 2]);
assert_equals(ind_xi2, [3, 4, 5]);
assert_equals(V{2}(ind_phi1, ind_xi1), V1{2})
assert_equals(V{2}(ind_phi2, ind_xi2), V2{2})

a1 = gpc_rand_coeffs(V1, 1);
a2 = gpc_rand_coeffs(V2, 1);
xi = gpcgerm_sample(V, 3);

ind1 = multiindex_find(V{2}(:,ind_xi1), V1{2});
ind2 = multiindex_find(V{2}(:,ind_xi2), V2{2});
a = a1(ind1) .* a2(ind2);

assert_equals(gpc_evaluate(a, V, xi), ...
    gpc_evaluate(a1, V1, xi(ind_xi1,:)).*gpc_evaluate(a2, V2, xi(ind_xi2,:)));



%% Inner product 
V1 = V_M23;
V2 = V_M24;
M1 = gpcbasis_size(V1,1);
M2 = gpcbasis_size(V2,1);
[V, ind_phi1, ind_phi2, ind_xi1, ind_xi2]=gpcbasis_combine(V1, V2, 'inner_product');
assert_equals(V{1}, 'M'); % 'hh' would be ok, too
%assert_equals(gpcbasis_size(V,1), max(M1,M2));
assert_equals(ind_xi1, [1, 2]);
assert_equals(ind_xi2, [1, 2]);
assert_equals(V{2}(ind_phi1, ind_xi1), V1{2})
assert_equals(V{2}(ind_phi2, ind_xi2), V2{2})

a1 = gpc_rand_coeffs(V1, 1);
a2 = gpc_rand_coeffs(V2, 1);
xi = gpcgerm_sample(V_h23, 3); % can't sample from "monomials"

[M11, M22] = meshgrid(1:M1, 1:M2);
I12 = [V1{2}(M11,1)+V2{2}(M22,1) V1{2}(M11,2)+V2{2}(M22,2)];
ind12 = multiindex_find(I12, V{2});
a12 = a2'*a1;
a = accumarray(ind12, a12(:))';

assert_equals(gpc_evaluate(a, V, xi), ...
    gpc_evaluate(a1, V1, xi(ind_xi1,:)).*gpc_evaluate(a2, V2, xi(ind_xi2,:)));



%% Test the "as_operator" stuff

% outer sum
V1 = V_h23;
V2 = V_l34;
[V, PrV1, PrV2, ResXi1, ResXi2]=gpcbasis_combine(V1, V2, 'outer_sum', 'as_operators', true);

a1 = gpc_rand_coeffs(V1, 1);
a2 = gpc_rand_coeffs(V2, 1);
xi = gpcgerm_sample(V, 3);
assert_equals(gpc_evaluate(a1 * PrV1 + a2 * PrV2, V, xi), ...
    gpc_evaluate(a1, V1, ResXi1 * xi) + gpc_evaluate(a2, V2, ResXi2 * xi), 'outer_sum_as_op');

% inner sum
V1 = V_h23;
V2 = V_h24;
[V, PrV1, PrV2, ResXi1, ResXi2]=gpcbasis_combine(V1, V2, 'inner_sum', 'as_operators', true);

a1 = gpc_rand_coeffs(V1, 1);
a2 = gpc_rand_coeffs(V2, 1);
xi = gpcgerm_sample(V, 3);
assert_equals(gpc_evaluate(a1 * PrV1 + a2 * PrV2, V, xi), ...
    gpc_evaluate(a1, V1, ResXi1 * xi) + gpc_evaluate(a2, V2, ResXi2 * xi), 'inner_sum_as_op');

% products are not so easy to test, needs lots of pce algebra and different
% mappings, so we don't do it here

