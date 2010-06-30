clc
for i=2:20
    fprintf( 'stats{%d}=[\n', i );
    
    c=1000000;
    p=1;
    while true
        I=multiindex(i,p);
        m=size(I,1);
        if m>500; break; end
        s=floor(c/m^2);
        nl=0; nz=0;
        for j=1:ceil(m/s)
            M=hermite_triple_fast( I((j-1)*s+1:min(j*s,m),:), I, I );
            nl=nl+numel(M); nz=nz+nnz(M);
        end
        
        fprintf( '%1d %5d %10d %10d %3d\n', p, size(I,1), nl, nz, round(1/(nz/nl)) );
        p=p+1;
    end
    fprintf( ']\n' );
end
