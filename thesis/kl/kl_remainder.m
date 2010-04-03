function s=kl_remainder(sigma,n)
s=sum(sigma.^2)-[0 cumsum(sigma.^2)];
s=s(1:n)/sum(sigma.^2);

