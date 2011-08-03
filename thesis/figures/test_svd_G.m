function x

test2

function test2

N=3;
M=4;

A=rand(N,M);

[U,S,V]=svd(A);
U'*A*V


B=[zeros(N) A; A' zeros(M)];
[W,D]=eig(B);
W=W(:,end:-1:end-3);
W'*B*W
V2=W(N+1:end,:)
U2=W(1:N,:)
V2=V2*diag(1./sqrt(sum(V2.^2,1)));
U2=U2*diag(1./sqrt(sum(U2.^2,1)));


U2'*A*V2
U'*A*V
1

function test1

N=3;
M=4;

G1=rand(N);
G1=G1*G1';
L1=chol(G1);

G2=rand(M);
G2=G2*G2';
L2=chol(G2);


A=rand(N,M);
AG=(L2*(L1*A)')';
AG=L1*A*L2';
%A-L1*AG*L2'

[UG,S,VG]=svd(AG)
U=L1\UG;
V=L2\VG;
norm(UG*S*VG'-AG)
norm(U*S*V'-A)
UG*UG'
(L1*U)'*(L1*U)
U'*G1*U
diag(S)



B=[zeros(N) A; A' zeros(M)];
BG=[zeros(N) AG; AG' zeros(M)];
s=sort(eig(BG),'descend');
s(1:min(N,M))
G=[G1 zeros(N,M); zeros(M,N) G2];
s=sort(eig(G*B*G',G),'descend');
s(1:min(N,M))


