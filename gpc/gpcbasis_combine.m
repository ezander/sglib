function [V, ind_phi1, ind_phi2, ind_xi1, ind_xi2]=gpcbasis_combine(V1, V2, mode, varargin)
% GPCBASIS_COMBINE Combines two GPC spaces into a new space.
%   [V, IND_PHI1, IND_PHI2, IND_XI1, IND_XI2]=GPCBASIS_COMBINE(V1, V2,
%   MODE) combines the GPC spaces V1 and V2 into a new space V, according
%   to the mode given. MODE can take on the following values:
%     'inner_sum': The spaces V1 are assumed to be subspaces of one larger
%       space (i.e. V1, V2 \subspace V) and all sums of vectors of V1 and
%       V2 can be represented in the returned space. The indices of the
%       original multiindices is returned in IND_PHI1 and IND_PHI2.
%     'outer_sum': The spaces V1 and V2 are assumed to be distinct (except
%       for the null vector, and the returned space is the
%       Cartesian product V = V1 x V2. The original spaces can be thought
%       to be embedded into the new space by V1 x {0} and {0} x V2. Every
%       sum of vectors of V1 and V2 can then be represented in V.
%     'inner_product': If the spaces V1 and V2 are algebras (which they are
%       in this case here), also products of vectors can be considered. The
%       space V, contains
%
% Options
%   as_operators: {false}, true
%      Returns instead of the indices prolongation operators for the
%      bases (from V1 and V2 to V) and restriction operators for the germ
%      variables (from xi to xi1 and xi2). While this choice may seem
%      arbitrary it is usually more useful in practice, and you can always
%      get the prolongation from the restriction by transposing the
%      operator (and vice versa, of course).
%
% Notes
%    'outer' always means that Omega1 and Omega2 are distinct. The germs
%    are distinct and independent. Omega1 x Omega2 is returned.
%    'inner' means that Omega1 and Omega2 are the same. That is the germs
%    are identical.
%    'sum' means all sums of vectors can of the original spaces can be
%    represented in the returned space.
%    'product' means all products of vectors, which are also elements of an
%    algebra (the gpc algebra) can be represented.
%
% Example (<a href="matlab:run_example gpcbasis_combine">run</a>)
%     % Create two basis and combine them so that sums can be represented
%     % exactly
%     V1 = gpcbasis_create('hl', 'p', 2);
%     V2 = gpcbasis_create('ptu', 'p', 3);
%     [V, PrV1, PrV2, ResXi1, ResXi2]=gpcbasis_combine(V1, V2, 'outer_sum', 'as_operators', true);
%     
%     % Now create coeffs for each basis and a set of random vectors in the
%     % combined space
%     a1_i_alpha = gpc_rand_coeffs(V1, 7);
%     a2_i_beta = gpc_rand_coeffs(V2, 7);
%     xi = gpcgerm_sample(V, 3);
%     
%     % The sum of evaluations of the restrictions in each space should be
%     % the same as the evaluation of the prolongated coefficients in the
%     % combined space
%     norm(...
%         gpc_evaluate(a1_i_alpha, V1, ResXi1 * xi) + ...
%         gpc_evaluate(a2_i_beta, V2, ResXi2 * xi) - ...
%         gpc_evaluate(a1_i_alpha * PrV1 + a2_i_beta * PrV2, V, xi))
%
% See also GPCBASIS_CREATE, GPCBASIS_MODIFY

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin, mfilename);
[as_operators,options]=get_option(options, 'as_operators', false);
check_unsupported_options(options);

I1 = V1{2};
I2 = V2{2};
switch mode
    case 'outer_sum'
        [I, ind_phi1, ind_phi2, ind_xi1, ind_xi2] = multiindex_outer_direct_sum(I1, I2);
        V = gpcbasis_create(gpcgerm_combine(V1, V2), 'I', I);
    case 'inner_sum'
        [I, ind_phi1, ind_phi2] = multiindex_inner_direct_sum(I1, I2);
        ind_xi1 = 1:size(I1,2); ind_xi2 = 1:size(I1,2);
        V = gpcbasis_create(V1, 'I', I);
    case 'outer_product'
        [I, ind_phi1, ind_phi2, ind_xi1, ind_xi2] = multiindex_outer_direct_product(I1, I2);
        V = gpcbasis_create(gpcgerm_combine(V1, V2), 'I', I);
    case 'inner_product'
        [I, ind_phi1, ind_phi2] = multiindex_inner_direct_product(I1, I2);
        ind_xi1 = 1:size(I1,2); ind_xi2 = 1:size(I1,2);
        V = gpcbasis_create(V1, 'I', I);
    otherwise
        error('sglib:gpcbasis_combine', 'unknown combination mode: %s', mode);
end

if as_operators
    [M, m] = gpcbasis_size(V);
    [M1, m1] = gpcbasis_size(V1);
    [M2, m2] = gpcbasis_size(V2);
    PrV1 = sparse(1:M1, ind_phi1, ones(1,M1), M1, M);
    PrV2 = sparse(1:M2, ind_phi2, ones(1,M2), M2, M);
    ResXi1 = sparse(1:m1, ind_xi1, ones(1,m1), m1, m);
    ResXi2 = sparse(1:m2, ind_xi2, ones(1,m2), m2, m);
    ind_phi1 = PrV1;
    ind_phi2 = PrV2;
    ind_xi1  = ResXi1;
    ind_xi2  = ResXi2;
end

function [I, ind_phi1, ind_phi2, Q1, Q2]=multiindex_outer_direct_sum(I1, I2)
Q1 = 1:size(I1,2);
Q2 = (1:size(I2,2)) + Q1(end);
[I11, I12] = multiindex_combine({I1, I2});
[I, ind_phi1, ind_phi2] = multiindex_inner_direct_sum(I11, I12);

function [I, ind_phi1, ind_phi2]=multiindex_inner_direct_sum(I1, I2)
If = [I1; I2];
I=multiindex_unique(If);
ind_phi1 = multiindex_find(I1, I);
ind_phi2 = multiindex_find(I2, I);

function [I, ind_phi1, ind_phi2, Q1, Q2]=multiindex_outer_direct_product(I1, I2)
Q1 = 1:size(I1,2);
Q2 = (1:size(I2,2)) + Q1(end);
[I11, I12] = multiindex_combine({I1, I2});
[I, ind_phi1, ind_phi2] = multiindex_inner_direct_product(I11, I12);

function [I, P1, P2]=multiindex_inner_direct_product(I1, I2)
n1 = size(I1,1);
n2 = size(I2,1);
[N1,N2]=meshgrid(1:n1,1:n2);
If = I1(N1(:),:) + I2(N2(:),:);
I=multiindex_unique(If);
P1 = multiindex_find(I1, I);
P2 = multiindex_find(I2, I);

function [I]=multiindex_unique(If)
I=unique(If, 'rows');
I=[sum(I,2), I(:,end:-1:1)];
I=sortrows(I);
I=I(:,end:-1:2);


function g=gpcgerm_combine(V1, V2)
g1 = V1{1};
m1 = gpcbasis_size(V1,2);
g2 = V2{1};
m2 = gpcbasis_size(V2,2);
if all(length(g1)~=[1,m1])
    error('sglib:gpc', 'GPC basis V1 inconsistent');
end
if all(length(g2)~=[1,m2])
    error('sglib:gpc', 'GPC basis V2 inconsistent');
end
if length(g1)==1
    g1 = repmat(g1, 1, m1);
end
if length(g2)==1
    g2 = repmat(g2, 1, m2);
end
g = [g1, g2];
