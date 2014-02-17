function y=pce_pdf_1d( xi, X_alpha, I_X )


V=gpcbasis_create('H', 'I', I_X);
y=gpc_pdf_1d(X_alpha, V, xi);


function y=gpc_pdf_1d(X_alpha, V, xi)

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
dp=polyder(p);


% Find zeros of polynomial plus endpoints at infinity and sum up weights
% over those intervals
y=zeros(size(xi));
for i=1:length(xi(:))
    r = find_poly_intervals(p, xi(i));
    val = gendist_pdf(r, dist) ./ polyval(dp, r);
    y(i) = sum([-1, 1] * reshape(val(:),2,[]));
    
end
