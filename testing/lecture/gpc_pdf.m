function p=gpc_pdf(V, xi)

sys = V{1};
I = V{2};
m = size(I,2);

check_match(I, xi, false, 'I', 'xi', mfilename);

if length(sys)==1
    p = prod(polysys_pdf(sys, xi), 1);
else
    check_range(length(sys), m, m, 'len(sys)==m', mfilename);
    p = ones(1, size(xi, 2));
    for j = 1:m
        p = p.* polysys_pdf(sys(j), xi(j, :));
    end
end
