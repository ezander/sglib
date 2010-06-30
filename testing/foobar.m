function foobar

for i=1:10
    A=rand(5);
    B=rand(7);
    C=rand(5);
    D=rand(7);
    [normx(kron(A,B))-normx(A)*normx(B)]
    [normx(kron(A,B)+kron(C,D)) (normx(A)*normx(B)+normx(C)*normx(D))]
end


function a=normx(v)
a=norm(v,2);
a=norm(v,'fro');
a=norm(v,1);
