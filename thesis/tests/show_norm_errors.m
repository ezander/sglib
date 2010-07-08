function show_norm_errors
M=3*53;
N=3*47;
R1=13;
R2=17;

clc
%randn('seed')
%randn('seed', 1018663534 );
randn('seed', 1776363387 );

T1={randn(M,R1), randn(N,R1)};
T2={randn(M,R2), randn(N,R2)};
t=tensor_norm(T1); T1{1}=T1{1}/t;

fprintf( 'inner: %g \n', inner1( T1, T2 ) );
fprintf( 'inner: %g \n', inner2( T1, T2 ) );
fprintf( 'inner: %g \n', inner4( T1, T2 ) );
fprintf( 'inner: %g \n', inner5( T1, T2 ) );

fprintf( 'norm T1: %g \n', norm1( T1 ) );
fprintf( 'norm T1: %g \n', norm2( T1 ) );
fprintf( 'norm T1: %g \n', norm3( T1 ) );
fprintf( 'norm T1: %g \n', norm4( T1 ) );
fprintf( 'norm T1: %g \n', norm5( T1 ) );


DT=gvector_add( T1, T1, -1 );
fprintf( 'norm DT: %g \n', norm1( DT ) );
fprintf( 'norm DT: %g \n', norm2( DT ) );
fprintf( 'norm DT: %g \n', norm3( DT ) );
fprintf( 'norm DT: %g \n', norm4( DT ) );
fprintf( 'norm DT: %g \n', norm5( DT ) );


deltas=10.^(-18:-4);
for i=1:1
    res=zeros(5,0);
    for delta=deltas
        fprintf( 'delta: %g \n', delta );
        t=tensor_to_array( T1 );
        dt=randn(size(t));
        dt=delta*dt/norm(dt,'fro');
        t=t+dt;
        [u,s,v]=svd( t );
        T2={u*s,v};
        
        
        DT=gvector_add( T1, T2, -1 );
        
        n1=norm1( DT );
        n2=norm2( DT );
        n3=norm3( DT );
        n4=norm4( DT );
        n5=norm5( DT );
        res(:,end+1)=[n1 n2 n3 n4 n5]';
    end
    if i==1
        r=res;
    else
        r=((i-1)*r+res)/i;
    end
end

multiplot_init(1,1);
y=abs(res([1,2,4,5],:));
y(y==0)=1e-18;
plot( deltas, y, 'x-' );
logaxis(gca,'xy');
legend('full tensor','inner product','orth. inner product','orth. (core) full tensor')
grid on
save_figure( gca, 'tensor_inner_product_methods' );

function s=norm1( T )
s=sqrt(inner1(T,T));

function s=inner1( T1, T2 )
M=(T1{1}*T1{2}').*(T2{1}*T2{2}');
s=sum(M(:));



function s=norm2( T )
s=sqrt(inner2(T,T));

function s=inner2( T1, T2 )
M=(T1{1}'*T2{1}).*(T1{2}'*T2{2});
s=sum(M(:));




function s=norm3( T )
[QA,RA]=qr(T{1},0);
[QB,RB]=qr(T{2},0);
s=norm(RA*RB','fro');


function s=norm4( T )
s=sqrt(inner4(T,T));

function s=inner4( T1, T2 )
Q1=orth( [T1{1}, T2{1}] );
Q2=orth( [T1{2}, T2{2}] );
R11=Q1'*T1{1};
R21=Q1'*T2{1};
R12=Q2'*T1{2};
R22=Q2'*T2{2};
M=(R11'*R21).*(R12'*R22);
s=sum(M(:));

function s=norm5( T )
s=sqrt(inner5(T,T));

function s=inner5( T1, T2 )
Q1=orth( [T1{1}, T2{1}] );
Q2=orth( [T1{2}, T2{2}] );
R11=Q1'*T1{1};
R21=Q1'*T2{1};
R12=Q2'*T1{2};
R22=Q2'*T2{2};
M=(R11*R12').*(R21*R22');
s=sum(M(:));

