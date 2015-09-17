function [k,err]=schattenp_truncate( sigma, eps, rel, p, maxk )

if nargin<5
    maxk=inf;
end
if isempty(sigma)
    k=0;
    err=0;
    return;
end

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
    k=min(k,maxk);
    err=(errp(k)/csp(end))^(1/p);
else
    if rel; 
        eps=eps*max(sigma); 
    end
    k=sum(sigma>=eps);
    k=min(k,maxk);

    if k<length(sigma)
        err=sigma(k+1)/max(sigma);
    else
        err=0;
    end
end
