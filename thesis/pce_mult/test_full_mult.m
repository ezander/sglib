function test_full_mult
st=[
0     1     1    1
 1     8     8    4
 2    27    27   11
 3    64    64   23
 4   125   125   42
 5   216   216   69
 6   343   343  106
 7   512   512  154
 8   729   729  215
 9  1000  1000  290
10  1331  1331  381
11  1728  1728  489
12  2197  2197  616
13  2744  2744  763
14  3375  3375  932
15  4096  4096 1124
16  4913  4913 1341
17  5832  5832 1584
18  6859  6859 1855
19  8000  8000 2155
20  9261  9261 2486
];

x=st(:,1); y=st(:,4); z=st(:,2);
a=polyfit( x, y, 2 )
plot( x, y, 'x-' ); hold on
plot( x, polyval(a,x), 'ro-' ); hold off;


x=st(:,1)+1; y=st(:,4);
a=polyfit( x, y, 3 )
plot( x, y, 'x-' ); hold on
plot( x, polyval(a,x), 'ro-' ); 
a(2:end)=0;
plot( x, polyval(a,x), 'ro-' ); hold off;



x=st(2:2:end,1); y=st(2:2:end,4);
a=polyfit( x, y, 3 )
plot( x, y, 'x-' ); hold on
plot( x, polyval(a,x), 'ro-' ); 
y-polyval(a,x)

x=st(1:2:end,1); y=st(1:2:end,4);
a=polyfit( x, y, 3 )
plot( x, y, 'x-' ); hold on
plot( x, polyval(a,x), 'ro-' ); 
y-polyval(a,x)

f=@(p)(1/8*(2*p.^3+9*p.^2+14*p+8-mod(p,2)));

4*(y-polyval(a,x))


for p=0:20
    I=multiindex(1,p,true,'full',true);
    M=hermite_triple_fast(I,I,I);
    fprintf('%2d %5d %5d %4d\n', [p numel(M), (p+1)^3, nnz(M)]);
    nu1=numel(M);
    nz1=nnz(M);
end
return




for p=0:4
    disp(p);
    I=multiindex(1,p,true,'full',true);
    M=hermite_triple_fast(I,I,I);
    disp([numel(M), nnz(M)]);
    nu1=numel(M);
    nz1=nnz(M);
    for m=2:3
        I=multiindex(m,p,true,'full',true);
        M=hermite_triple_fast(I,I,I);
        disp([numel(M), nu1^m, (p+1)^(3*m), nnz(M), nz1^m]);
    end
end

