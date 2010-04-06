function mh=multiplot_init( m, n )
fh=clf;
set( fh, 'defaulttextinterpreter', 'none' );
mh={{m,n}};
for i=1:m
    for j=1:n
        k=j+n*(i-1);
        h=subplot( m, n, k );
        set( h, 'tag', sprintf('$mp:%d%d', i, j ) );
        mh=[mh, {h}];
    end
end

