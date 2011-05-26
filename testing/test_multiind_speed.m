maxm=50;
maxp=50;
maxt=1;

sz=nan*ones(maxm,maxp);
tm=inf*ones(maxm,maxp);
tm2=inf*ones(maxm,maxp);

for m=1:maxm
    for p=1:maxp
        fprintf( 'm=%d, p=%d\n', m, p );
        tic
        A=multiindex(m,p,true,'use_sparse', true);
        t=toc;
        tic
        A=multiindex2(m,p);
        t2=toc;
        sz(m,p)=size(A,1);
        tm(m,p)=t;
        tm2(m,p)=t2;
        if t>maxt; break; end
    end
end
  
%sz
%tm


