function house

format short g
format compact
%rand('seed', 1234 );

N=5;
A=rand(N)-0.5;
G=rand(N); G=G*G';
I=eye(N);

A
[Q,R]=house1(A);
[Q,R]=house2(A,G);
norm(A-Q*R)
norm(I-Q'*Q)
norm(tril(R,-1))

function [Q,R]=house1(A)
N=length(A);
I=eye(N);
Q=I; R=A;
for i=1:N-1
    u=R(:,i);
    e=accumarray(i,1,[N,1]);
    u(1:i-1)=0;
    sign(u(i))
    v=u+sign(u(i))*norm(u)*e;
    %v=u-norm(u)*e;
    v=v/norm(v);
    H=I-2*(v*v');
    Q=Q*H;
    R=H*R;
end



function [Q,R]=house2(A,G)
N=length(A);
I=eye(N);
Q=I; R=A;
L=chol(G);
for i=1:N-1
    u=R(:,i);
    e=accumarray(i,1,[N,1]);
    u(1:i-1)=0;
    sign(u(i))
    v=u+sign(u(i))*sqrt(u'*G*u)*e;
    %v=u-norm(u)*e;
    v=v/sqrt(v'*G*v);
    H=I-2*(v*v'*G);
    Q=Q*H;
    R=H*R;
end



%    H=I-2*(v*v');
%    H=I-2 v <v|
%    Hx=x-2 v <v|x>
%    HHx=x-2 v <v|x>-2 v <v|x-2 v <v|x>>
%    HHx=x-2 v <v|x>-2 v (<v|x> -2<v|x><v|v>)
%    HHx=x-2 v <v|x>-2 v <v|x> +4 <v|x>

