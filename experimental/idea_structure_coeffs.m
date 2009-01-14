function idea_structure_coeffs

n=5;
convol_mat( n, 1 )
convol_mat( n, 2 )
convol_mat( n, 3 )
H=hermite(n, true)'
Hb=hermite(2*n, true)'


p=rand(n+1,1)/10;
q=rand(n+1,1);
r=myconv( p, q ); r'
norm(r-conv( p, q ))<1e-10
pc=(H\p);
norm(herm2poly(pc)-p)<1e-10
norm(H*pc-p)<1e-10
qc=(H\q);

(Hb\r)'
rc2=Hb\(myconv(H*pc,H*qc));rc2'
rc3=herm_conv(pc,qc);rc3'
rc4=herm_conv2(pc,qc);rc4'



function p=herm2poly( pc )
p=[];
for i=1:length(pc)
    h=hermite(i-1);
    p=[0 p]+pc(i)*h;
end
p=p';

function r=myconv( p, q )
n=length(p);
r=zeros(2*n-1,1);
for i=1:2*n-1
    r(i)=p'*convol_mat( n, i )*q;
end

function r=herm_conv( p, q )
n=length(p);
r=zeros(2*n-1,1);
for i=1:2*n-1
    for j=1:n
        for k=1:n
            cijk=hermite_triple_product(i-1,j-1,k-1)/factorial(i-1);
            r(i)=r(i)+cijk*p(j)*q(k);
            %cijk
        end
    end
end

function r=herm_conv2( p, q )
n=length(p);
r=zeros(2*n-1,1);
for i=1:2*n-1
    r(i)=p'*herm_convol_mat( n, i )*q;
end


function C=convol_mat( n, m )
i=(1:m);
j=(m:-1:1);
s=ones(1,m);
ind=(i<=n)&(j<=n);
C=full(sparse(i(ind),j(ind),s(ind),n,n));

function C=herm_convol_mat( n, m )
C=zeros(n,n);
for j=1:n
    for k=1:n
        C(j,k)=hermite_triple_product(m-1,j-1,k-1)/factorial(m-1);
    end
end
CU=convol_mat( n, m );
H=hermite( n-1, true );
Hx=H(:,end:-1:1)';
G=gaussian_matrix( n );


function G=gaussian_matrix( n )
[i,j]=meshgrid(1:n, 1:n);i=i(:);j=j(:);
s=0*i;
ind=(mod(i+j,2)==0);
s(ind)=abs((i(ind)+j(ind)-3));
s(ind)=factorial(s(ind))./(2.^((s(ind)-1)/2 ) .* factorial( (s(ind)-1)/2 )  );
G=full(sparse(i,j,s));



