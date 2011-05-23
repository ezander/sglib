N=6; 
A1=rand(N); 
A2=rand(N); 
A3=rand(N); 
A4=rand(N); 
A=[A1 A2; A3 A4];

d1=det(A1);
d2=det(A2);
d3=det(A3);
d4=det(A4);
clc
d=det(A)
dd=det([d1 d2; d3 d4])



