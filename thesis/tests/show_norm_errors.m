function show_norm_errors
M=53;
N=47;
R1=13;
R2=17;

T1={randn(M,R1), randn(N,R1)};
T2={randn(M,R2), randn(N,R2)};

fprintf( 'inner: %g \n', inner1( T1, T2 ) );
fprintf( 'inner: %g \n', inner2( T1, T2 ) );
fprintf( 'inner: %g \n', inner3( T1, T2 ) );

fprintf( 'norm T1: %g \n', norm1( T1 ) );
fprintf( 'norm T1: %g \n', norm2( T1 ) );
fprintf( 'norm T1: %g \n', norm3( T1 ) );
fprintf( 'norm T1: %g \n', norm4( T1 ) );

T2=T1;
DT=gvector_add( T1, T2, -1 );

fprintf( 'norm DT: %g \n', norm1( DT ) );
fprintf( 'norm DT: %g \n', norm2( DT ) );
fprintf( 'norm DT: %g \n', norm3( DT ) );
fprintf( 'norm DT: %g \n', norm4( DT ) );


function s=norm1( T )
s=sqrt(inner1(T,T));

function s=inner1( T1, T2 )
M=(T1{1}'*T2{1}).*(T1{2}'*T2{2});
s=sum(M(:));

function s=norm2( T )
s=sqrt(inner2(T,T));

function s=inner2( T1, T2 )
M=(T1{1}*T1{2}').*(T2{1}*T2{2}');
s=sum(M(:));

function s=norm3( T )
s=sqrt(inner3(T,T));

function s=inner3( T1, T2 )
K1=tensor_rank(T1);
K2=tensor_rank(T2);
[Q1,R1]=qr( [T1{1}, T2{1}] );
[Q2,R2]=qr( [T1{2}, T2{2}] );
R11=R1(:,1:K1);
R21=R1(:,K1+1:end);
R12=R2(:,1:K1);
R22=R2(:,K1+1:end);
M=(R11'*R21).*(R12'*R22);
s=sum(M(:));

function s=norm4( T )
[QA,RA]=qr(T{1},0);
[QB,RB]=qr(T{2},0);
s=norm(RA*RB','fro');
