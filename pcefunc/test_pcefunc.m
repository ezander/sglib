clc
N=8;
x=10i;
for i=1:N
    a=zeros(1,N);
    a(i)=1;
    i
    abs(pce_hermite_val(a,x,0))
    abs(hermite_val(a,x))
end

a=rand(1,N);
x=rand(7,1);
abs(pce_hermite_val(a,x,0))
abs(hermite_val(a,x))
