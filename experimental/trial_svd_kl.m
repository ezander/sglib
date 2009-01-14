function trial_svd_kl




n=10; 
m=20; 
k=4;
A=rand(n,k);
B=rand(m,k);

FA=rand(n,n); MA=FA'*FA; LA=chol(MA);
FB=rand(m,m); MB=FB'*FB; LB=chol(MB);

[QA,RA]=gram_schmidt( A, MA, false, 2 );
[QB,RB]=gram_schmidt( B, MB, false, 2 );
[U,S,V]=svd(RA*RB');
A1=QA*U*S;
B1=QB*V;
norm(A1*B1'-A*B')
norm(B1'*MB*B1-eye(k))


[QA,RA]=qr( LA*A, 0 );
[QB,RB]=qr( LB*B, 0 );
[U,S,V]=svd(RA*RB');
A2=LA\QA*U*S;
B2=LB\QB*V;
norm(A2*B2'-A*B')
norm(B2'*MB*B2-eye(k))

norm(A1*B1'-A2*B2')

return




n=10; m=20; k=10;
n=4; k=4;
A=rand(n,k);
B=rand(m,k);

FA=rand(n,n); MA=FA'*FA; LA=chol(MA);
FB=rand(m,m); MB=FB'*FB; LB=chol(MB);

[QA,RA]=gram_schmidt( A, B, false, 2 );
[QB,RB]=gram_schmidt( A, B, false, 2 );




return;



%[Q,R]=gram_schmidt( A, MA );
A=A+A';
M=MA;
[UM,D]=eig(A,M)
fprintf( '%-4s: |D-diag(D)|=%- 8.3e   |Q''MQ-I| =%- 8.3e   |A-QR|=%- 8.3e  %- 8.3e %- 8.3e \n',  ...
    'gs', ...
    norm(D-diag(diag(D))), ...
    norm(UM'*M*UM-eye(size(D,2))), ...
    norm(A*UM-M*UM*D), ...
    norm(A-M*UM*D*inv(UM)), ...
    norm(A-(M*UM)*D*(M*UM)') )

[Q,R]=gram_schmidt(A,MA);
[V,D]=eig(Q'*A*Q);
UM=Q*V;
fprintf( '%-4s: |D-diag(D)|=%- 8.3e   |Q''MQ-I| =%- 8.3e   |A-QR|=%- 8.3e  %- 8.3e %- 8.3e \n',  ...
    'gs', ...
    norm(D-diag(diag(D))), ...
    norm(UM'*M*UM-eye(size(D,2))), ...
    norm(A*UM-M*UM*D), ...
    norm(A-M*UM*D*inv(UM)), ...
    norm(A-(M*UM)*D*(M*UM)') )


keyboard

return




n=4; k=3;
x=rand(n,1)-0.5;
e=zeros(n,1); e(1:k)=1;
v=house_vec( x, k );
v2=house_vec2( x, k );
H=house( v );
H2=house( v2 );
y=H*x;
y2=H2*x;
x2=H*y;
[x,y,y2,e,v,v2]


function v=house_vec( x, k )
u=zeros(size(x));
u(k:end)=x(k:end);
e=zeros(size(x));
e(k)=sign(x(k));
u=u/norm(u);
v=(u+e);
v=v/norm(v);

function v=house_vec2( x, k )
n=size(x,1);
v=zeros(n,1);
g=norm(x(k:n));
p=sign(x(k));
s=sqrt(2*g*(g+p*x(k)));
v(k)=(x(k)+p*g)/s;
v(k+1:n)=x(k+1:n)/s;


function H=house( v )
H=eye(length(v))-2*v*v'/(v'*v);


function bla





[Q,R]=gram_schmidt( A );
fprintf( '%-4s: |R-triu(R)|=%- 8.3e   |Q''Q-I| =%- 8.3e   |A-QR|=%- 8.3e \n',  ...
    'gs', ...
    norm(R-triu(R)), ...
    norm(Q'*Q-eye(size(Q,2))), ...
    norm(A-Q*R))

[Q,R]=gram_schmidt( A, [], true );
fprintf( '%-4s: |R-triu(R)|=%- 8.3e   |Q''Q-I| =%- 8.3e   |A-QR|=%- 8.3e \n',  ...
    'mgs', ...
    norm(R-triu(R)), ...
    norm(Q'*Q-eye(size(Q,2))), ...
    norm(A-Q*R))

[Q,R]=gram_schmidt( A, [], [], 2 );
fprintf( '%-4s: |R-triu(R)|=%- 8.3e   |Q''Q-I| =%- 8.3e   |A-QR|=%- 8.3e \n',  ...
    'gsc2', ...
    norm(R-triu(R)), ...
    norm(Q'*Q-eye(size(Q,2))), ...
    norm(A-Q*R))


[Q,R]=gram_schmidt( A, MA );
fprintf( '%-4s: |R-triu(R)|=%- 8.3e   |Q''MQ-I|=%- 8.3e   |A-QR|=%- 8.3e \n',  ...
    'cgs', ...
    norm(R-triu(R)), ...
    norm(Q'*MA*Q-eye(size(Q,2))), ...
    norm(A-Q*R))

[Q,R]=gram_schmidt( A, MA, true );
fprintf( '%-4s: |R-triu(R)|=%- 8.3e   |Q''MQ-I|=%- 8.3e   |A-QR|=%- 8.3e \n',  ...
    'mcgs', ...
    norm(R-triu(R)), ...
    norm(Q'*MA*Q-eye(size(Q,2))), ...
    norm(A-Q*R))

[Q,R]=gram_schmidt( A, MA, [], 2 );
fprintf( '%-4s: |R-triu(R)|=%- 8.3e   |Q''MQ-I|=%- 8.3e   |A-QR|=%- 8.3e \n',  ...
    'cgs2', ...
    norm(R-triu(R)), ...
    norm(Q'*MA*Q-eye(size(Q,2))), ...
    norm(A-Q*R))

[Q,R]=gram_schmidt( A, MA, true, 2 );
fprintf( '%-4s: |R-triu(R)|=%- 8.3e   |Q''MQ-I|=%- 8.3e   |A-QR|=%- 8.3e \n',  ...
    'cgs2', ...
    norm(R-triu(R)), ...
    norm(Q'*MA*Q-eye(size(Q,2))), ...
    norm(A-Q*R))



R_k=sparse_svd_scaled( {A,B}, {LA,LB}, 5 )


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sigma=1e-7;
A=[1 1 1; sigma*eye(3)];
[Q,R]=gram_schmidt( A);
fprintf( '%-4s: |R-triu(R)|=%- 8.3e   |Q''Q-I| =%- 8.3e   |A-QR|=%- 8.3e \n',  ...
    'gs', ...
    norm(R-triu(R)), ...
    norm(Q'*Q-eye(size(Q,2))), ...
    norm(A-Q*R))

[Q,R]=gram_schmidt( A, [], true );
fprintf( '%-4s: |R-triu(R)|=%- 8.3e   |Q''Q-I| =%- 8.3e   |A-QR|=%- 8.3e \n',  ...
    'mgs', ...
    norm(R-triu(R)), ...
    norm(Q'*Q-eye(size(Q,2))), ...
    norm(A-Q*R))

[Q,R]=gram_schmidt( A, [], false, 2 );
fprintf( '%-4s: |R-triu(R)|=%- 8.3e   |Q''Q-I| =%- 8.3e   |A-QR|=%- 8.3e \n',  ...
    'gsc2', ...
    norm(R-triu(R)), ...
    norm(Q'*Q-eye(size(Q,2))), ...
    norm(A-Q*R))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






function R_k=sparse_svd_scaled( R, L, k )
R_k=sparse_svd( { L{1}*R{1}, L{2}*R{2} }, k );
R_k={ L{1}\R_k{1}, L{2}\R_k{2} };


function R_k=sparse_svd( R, k )
A=R{1};
B=R{2};
[QA,RA]=qr(A);
[QB,RB]=qr(B);
[U,S,V]=truncated_svd(RA*RB',k);
R_k={QA*U*S,QB*V};


function [U,S,V]=truncated_svd( A, k )
[U,S,V]=svd( A, 'econ' );
U=U(:,1:k);
S=S(1:k,1:k);
V=V(:,1:k);

