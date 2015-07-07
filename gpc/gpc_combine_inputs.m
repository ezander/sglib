function [a_beta, V]=gpc_combine_inputs(a1_alpha, V1, a2_alpha, V2)
% GPC_COMBINE_INPUTS Combines input paramteres or fields into one GPC space.
%   [A_BETA, V]=GPC_COMBINE_INPUTS(A1_ALPHA, V1, A2_ALPHA, V2) combines the
%   GPC parameters (or input fields or whatever) specified with A1_ALPHA
%   and V1 and A2_ALPHA and V2 into one GPC described by the coefficients
%   A_BETA and the GPC basis V. If V1 contains m1 random variables and V2
%   contains m2 random variable, then V will contain m1+m2. If V1 constists
%   of  M1 basis functions and V2 contains M2 basis functions (i.e.
%   polynomials in those m1/m2 random variables) then V consists of M1+M2-1
%   basis functions (-1, because the "deterministic" basis function is
%   contained in both V1 and V2).
%   The coefficients A1_ALPHA and A2_ALPHA are mapped into A_BETA such that
%   they refer to the same basis functions in the larger GPC space V and
%   such that the functions referred to by A1_ALPHA come first, and those
%   from A2_ALPHA below.
%   
%   The space V can be seen as the (outer) direct product of the spaces V1
%   and V2 (except for the "deterministic" dimension).
%
% Note:
%   The effect of this combine method can be seen as follows: If the first
%   GPC is a parametrisation of the function f1(x) and the second of f2(y),
%   then the combined GPC parameterised the function f(x,y), such that
%   f(x,0)=[f1(x);0] and f(0,y)=[0;f2(y)].
%
% Example (<a href="matlab:run_example gpc_combine_inputs">run</a>)
%   % Create two GPC bases and related coefficient arrays
%   V1 = gpcbasis_create('hh', 'p', 4);
%   a1_alpha = rand(2, gpcbasis_size(V1,1));
%   V2 = gpcbasis_create('ppp', 'p', 2);
%   a2_alpha = rand(5, gpcbasis_size(V2,1));
%
%   % Combine the GPC spaces and coefficient array 
%   [a_beta, V] = gpc_combine_inputs(a1_alpha, V1, a2_alpha, V2);
% 
%   
%   xi1 = gpcgerm_sample(V1, 10);
%   xi2 = gpcgerm_sample(V2, 10);
%   xi = [xi1; xi2];
%   s1 = gpc_evaluate(a1_alpha, V1, xi1);
%   s2 = gpc_evaluate(a2_alpha, V2, xi2);
%   s = gpc_evaluate(a_beta, V, xi);
%   norm(s - [s1;s2]);
%
% See also GPCBASIS_CREATE, GPC_EVALUATE

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

if nargin==1 && iscell(a1_alpha)
    gpcs = a1_alpha;
    a_beta = zeros(0,0);
    V = gpcbasis_create('');
    for i=1:2:length(gpcs)
        [a_beta, V] = gpc_combine_inputs(a_beta, V, gpcs{i}, gpcs{i+1});
    end
    return
end

I1 = V1{2};
I2 = V2{2};
[I11, I12] = multiindex_combine({I1, I2});
[I, P1, P2] = multiindex_direct_sum(I11, I12);
V = gpcbasis_create(gpcgerm_combine(V1, V2), 'I', I);

a1_beta = zeros(size(a1_alpha,1), gpcbasis_size(V,1));
a1_beta(:,P1) = a1_alpha;
a2_beta = zeros(size(a2_alpha,1), gpcbasis_size(V,1));
a2_beta(:,P2) = a2_alpha;

a_beta = [a1_beta; a2_beta];

function [I, P1, P2]=multiindex_direct_sum(I1, I2)
If = [I1; I2];
I=unique(If, 'rows');
P1 = multiindex_find(I1, I);
P2 = multiindex_find(I2, I);

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
