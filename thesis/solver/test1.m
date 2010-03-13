clear
x1=rand(10,5);
[q1,r1]=qr(x1,0);
u1=q1;
u2=rand(10,3);
u=[u1 u2];

u2t=u2-u1*u1'*u2;
[q2 r2]=qr(u2t,0);

q=[q1 q2];
P=q1'*u2;
r=[eye(5), P;zeros(3,5), r2];
norm(q*r-u)




rat