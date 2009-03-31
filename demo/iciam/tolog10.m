function l=tolog10( d )
l=abs(d/d(1));
l(l<1e-18)=1e-18;
l=log10(l); 
%l=log(l); 
%l(l<-20)=-20;


%%
