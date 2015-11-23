function y=gpc_cdf_1d(a_alpha, V_a, x)
% GPC_CDF_1D Comute CDF of univariate GPC.
%   Y=GPC_CDF_1D(A_ALPHA, V_A, X) computes the cumulative distribution
%   function (CDF) of the GPC variable A given by A_ALPHA and V_A at the
%   point in X. This method works only for univariate GPC variable, i.e.
%   GPCs that depend on only a one dimensional germ (see Notes).
%   GPC_CDF_1D Long description of gpc_cdf_1d.
%
% Notes: This algorithm works by solving the polynomial inequality
%   A(XI)<=X associated with F_A(X)=P(A(XI)<=X). This gives intervals
%   XI_I=[A_I, B_I] in which the inequality is fulfilled. Then P(A(XI)<=X)
%   is given by the sum over F_XI(B_I)-F_XI(A_I), where F_XI is the GPC of
%   the germ. 
%
% Example (<a href="matlab:run_example gpc_cdf_1d">run</a>)
%
% See also GPCBASIS_CREATE, GPC_PDF_1D

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

% Determine some parameters
I=V_a{2};
if size(I,2)~=1
    error( 'sglib:gpc_cdf_1d:dim_error', 'Function works only for univariate GPC expansions.' )
end

syschar=V_a{1};
dist=polysys_dist(syschar);

% Determine the polynomial
deg=max(I);
P=polysys_rc2coeffs(polysys_recur_coeff(syschar, deg));
p=a_alpha*P;
while(~isempty(p) && ~p(1)); p(1)=[]; end

% Find zeros of polynomial plus endpoints at infinity and sum up weights
% over those intervals
y=zeros(size(x));
for i=1:length(x(:))
    r = find_poly_intervals(p, x(i));
    val = gendist_cdf(r, dist);
    y(i) = sum([-1, 1] * val);
end
