clc
%N=1500;
N=200;
K=rand(N);
f=rand(N,1);

Nc=3*10^7/N^2;
k_fh=@(x)(K*x);
kt_func={@tensor_operator_apply,{K},{1}};
km_func={@mtimes,{K},{1}};
Nc
tic; for i=1:Nc; dummy1=K*f; end; toc; t1=toc;
tic; for i=1:Nc; dummy2=funcall( kt_func, f ); end; toc; t2=toc;
tic; for i=1:Nc; dummy3=k_fh( f ); end; toc; t3=toc;
tic; for i=1:Nc; dummy4=funcall( km_func, f ); end; toc; t4=toc;

format compact
format short g
[t1/t1+0.001, t2/t1, t3/t1, t4/t1]'

