function show_accuracy

sd=12346;
rand('seed', sd);
randn('seed', sd);

[A, P, F, U]=setup_test_system( 53, 47, 3, 1.0, 0.5, 0.2 );

clc
F2=operator_apply( A, U );
gvector_error( F, F2, 'relerr', true )
gvector_error( tensor_to_vector(F), tensor_to_vector(F2), 'relerr', true )

% gvector_error( F, F, 'relerr', true )
% gvector_error( F2, F2, 'relerr', true )
%gvector_error( F, F2, 'relerr', true )

DF=gvector_add( F, F2, -1 );
%DF=gvector_add( F2, F2, -1 );
M1=(DF{1}'*DF{1}).*(DF{2}'*DF{2});
sqrt(sum1(M1(:)))/gvector_norm(F)
sqrt(sum2(M1(:)))/gvector_norm(F)

M2=(DF{1}*DF{2}').*(DF{1}*DF{2}');
sqrt(sum(M2(:)))/gvector_norm(F)

M3a=tensor_to_array(DF);
M3=M3a.*M3a;
sqrt(sum(M3(:)))/gvector_norm(F)

DF=gvector_add( F, F2, -1 );
[QA,RA]=qr(DF{1},0);
[QB,RB]=qr(DF{2},0);
norm(RA*RB','fro')




function y=sum1( x )
y=sum(x);

function y=sum2( x )
xp=x(x>0);
xn=-x(x<0);
yp=sum(sort(xp));
yn=sum(sort(xn));
y=yp-yn;

