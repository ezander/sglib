function p=nprimes(m)
if m==0
    p=zeros(1,0);
    return
end
% follows from prime number theorem plus some fitting (i.e. the number of
% of primes smaller than n  is always slightly larger than m)
n = m * log(m) * 1.2 + 3;
p = primes(n);
% the following loop should never execute (its just a precaution, since the
% formula for n above is not guaranteed)
while length(p)<m
    n = n * 2;
    p = primes(n);
end
p = p(1:m);
   

