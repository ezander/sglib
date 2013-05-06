function q = van_der_corput(n, p)
assert(all(n(:)>=0))
assert(all(n(:)==round(n(:) )))

q = zeros(size(n));
f = 1/p;
while true
    r = rem(n, p);
    q = q + f * r;
    n = floor(n/p);
    if all(n(:)==0)
        break;
    end
    f = f/p;
end

