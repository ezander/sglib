tic; for i=1:Nc; dummy=funcall( km_func, f ); end; toc; t=[t; toc];

%clc
%N=1500;
N=3000;
K=rand(N);
f=rand(N,1);

Nc=3*10^7/N^2;
k_fh=@(x)(K*x);
kt_func={@tensor_operator_apply,{K},{1}};
km_func={@mtimes,{K},{1}};
Nc
t=[];
tic; for i=1:Nc; dummy=K*f; end; toc; t=[t; toc];
tic; for i=1:Nc; dummy=funcall( @mtimes, K, f ); end; toc; t=[t; toc];
tic; for i=1:Nc; dummy=funcall( {@mtimes, {K}, {1}}, f ); end; toc; t=[t; toc];

tic; for i=1:Nc; dummy=k_fh( f ); end; toc; t=[t; toc];
tic; for i=1:Nc; dummy=funcall( k_fh, f ); end; toc; t=[t; toc];

tic; for i=1:Nc; dummy=tensor_operator_apply( K, f ); end; toc; t=[t; toc];
tic; for i=1:Nc; dummy=funcall( @tensor_operator_apply, K, f ); end; toc; t=[t; toc];
tic; for i=1:Nc; dummy=funcall( {@tensor_operator_apply, {K}, {1}}, f ); end; toc; t=[t; toc];
tic; for i=1:Nc; dummy=funcall( kt_func, f ); end; toc; t=[t; toc];

format compact
format short g
t/t(1)'

