for p=2:20
    fprintf( 'stats{%d}=[\n', p );
    
    c=1000000;
    i=1;
    while true
        I=multiindex(i,p);
        m=size(I,1);
        if m>50; break; end
        s=floor(c/m^2);
        nl=0; nz=0;
        for j=1:ceil(m/s)
            M=hermite_triple_fast( I((j-1)*s+1:min(j*s,m),:), I, I );
            nl=nl+numel(M); nz=nz+nnz(M);
        end
        
        fprintf( '%1d %5d %10d %10d %3d\n', i, size(I,1), nl, nz, round(1/(nz/nl)) );
        i=i+1;
    end
    fprintf( ']\n' );
end

