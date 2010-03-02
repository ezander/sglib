function k=schattenp_truncate( sigma, eps, rel, p )

if isfinite(p)
    csp=cumsum(sigma.^p);
    if rel; eps=eps*csp(end); end
    k=find(csp(end)-csp<=eps^p,1,'first');
else
    if rel; eps=eps*sigma(end); end
    k=sum(sigma>=eps);
end
