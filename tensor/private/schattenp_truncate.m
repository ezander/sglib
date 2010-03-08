function k=schattenp_truncate( sigma, eps, rel, p )

sigma=sigma(:);
if isfinite(p)
    csp=cumsum(flipud(sigma).^p);
    if rel
        tol=eps^p*csp(end);
    else
        tol=eps^p;
    end
    errp=flipud([0; csp(1:end-1)]);
    k=find(errp<=tol,1,'first');
else
    if rel; 
        eps=eps*max(sigma); 
    end
    k=sum(sigma>=eps);
end
