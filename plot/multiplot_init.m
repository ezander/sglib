function mh=multiplot_init( m, n )
fh=clf;
set( fh, 'defaulttextinterpreter', 'none' );
mh=zeros(m,n);
for i=1:m
    for j=1:n
        k=j+n*(i-1);
        h=subplot( m, n, k ); 
        hold all;
        set( h, 'tag', sprintf('$mp:%d%d', i, j ) );
        mh(i,j)=h;
    end
end
multiplot(mh,m,n);

if nargout==0
    clear mh
end
