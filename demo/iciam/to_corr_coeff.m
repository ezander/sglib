function Cn=to_corr_coeff( C )
s=sqrt(diag(C));
V=s*(s');
Cn=C;
Cn(V~=0)=C(V~=0)./V(V~=0);
Cn(V==0)=1;


%%
