function y=pce_cdf_1d( xi, X_alpha, I_X )
% PCE_CDF_1D Compute cumulative distribution for univariate PCE.
%   PCE_CDF_1D Long description of pce_cdf_1d.
%
% Example (<a href="matlab:run_example pce_cdf_1d">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

V=gpcbasis_create('H', 'I', I_X);
y=gpc_cdf_1d(X_alpha, V, xi);


function y=gpc_cdf_1d(X_alpha, V, xi)

% Determine some parameters
I=V{2};
sys=V{1};
dist=polysys_dist(sys);

if ~size(I,2)==1
    error( 'gpc_cdf_1d:dim_error', 'Function works only for univariate GPC expansions.' )
end

% Determine the polynomial
deg=max(I);
P=polysys_rc2coeffs(polysys_recur_coeff(sys, deg));
p=X_alpha*P;
while(~isempty(p) && ~p(1)); p(1)=[]; end

% Find zeros of polynomial plus endpoints at infinity and sum up weights
% over those intervals
y=zeros(size(xi));
for i=1:length(xi(:))
    r = find_poly_intervals(p, xi(i));
    val = gendist_cdf(r, dist);
    y(i) = sum([-1, 1] * reshape(val(:),2,[]));
end
