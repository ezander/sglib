function y=gpc_pdf_1d(X_alpha, V, xi)
% GPC_PDF_1D Comute PDF of univariate GPC.
%   Y=GPC_PDF_1D(A_ALPHA, V_A, X) computes the probability distribution
%   function (PDF) of the GPC variable A given by A_ALPHA and V_A at the
%   point in X. This method works only for univariate GPC variable, i.e.
%   GPCs that depend on only a one dimensional germ (see Notes).
%   GPC_PDF_1D Long description of gpc_pdf_1d.
%
% Notes: This algorithm works by solving the polynomial inequality
%   A(XI)<=X associated with F_A(X)=P(A(XI)<=X). This gives intervals
%   XI_I=[A_I, B_I] in which the inequality is fulfilled. Then P(A(XI)<=X)
%   is given by the sum over F_XI(B_I)-F_XI(A_I), where F_XI is the GPC of
%   the germ. 
%
% Example (<a href="matlab:run_example gpc_pdf_1d">run</a>)
%   dist=gendist_create('beta', {3, 2}, 'shift', 0.5);
%   for i=1:4
%     deg=3*i;
%     [X_alpha, V_X] = gpc_param_expand(dist, 'H', 'p', deg);
%     
%     xi = linspace(0.3, 2, 100);
%     y=gpc_pdf_1d(X_alpha, V_X, xi);
%     subplot(2,2,i); 
%     plot(xi,y); hold all;
%     y=gendist_pdf(xi,dist);
%     plot(xi, y, '-..'); hold off;
%  end
%
% See also GPCBASIS_CREATE, GPC_CDF_1D

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
I=V{2};
if size(I,2)~=1
    error( 'sglib:gpc_pdf_1d:dim_error', 'Function works only for univariate GPC expansions.' )
end

syschar=V{1};
dist=polysys_dist(syschar);

% Determine the polynomial
deg=max(I);
P=polysys_rc2coeffs(polysys_recur_coeff(syschar, deg));
p=X_alpha*P;
while(~isempty(p) && ~p(1)); p(1)=[]; end
dp=polyder(p);


% Find zeros of polynomial plus endpoints at infinity and sum up weights
% over those intervals
y=zeros(size(xi));
for i=1:length(xi(:))
    r = find_poly_intervals(p, xi(i));
    val = gendist_pdf(r, dist) ./ polyval(dp, r);
    y(i) = sum([-1, 1] * val);
    
end
