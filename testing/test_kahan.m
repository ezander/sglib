function test_kahan

format long e
x=[0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1];
sum(x)
kahan_sum(x)

function s=kahan_sum( x )
c=0;
s=0;
for i=1:numel(x)
    y=x(i)+c;
    t=s+y;
    c=y-(t-s);
    s=t;
end
