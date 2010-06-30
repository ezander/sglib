function foobaz

load TS2
show(U,T,S)

%comp_3p
return

function show(U,T,S)
%[U S T]
regplot( U, 1, T, 1, 6)
regplot( U, 3, T, 1, 6)
regplot( S, 1, T, 1, 6)
regplot( S, 2, T, 1, 6)

function r=regplot( A, i1, B, i2, s )
a=log10(A(s:end,i1));
b=log10(B(s:end,i2));
r=polyfit( a, b, 1);
plot( a, b, 'x', a, polyval(r,a), '-' );
r=r(1);

function comp_m3
T=[];
S=[];
U=[];

for i=1:15
    I_A=multiindex(i,3);
    U(i,:)=[size(I_A), prod(size(I_A))];
    
    disp(' ');
    
    tic; fprintf( 'sparse: %dx%d ', size(I_A) );
    try
        M=hermite_triple_fast(I_A,I_A,I_A,'algorithm','sparseb');
        toc;
        T(i,1)=toc;
        S(i,1)=nnz(M);
        S(i,2)=numel(M);
    catch
        disp( 'Aborted' );
    end

    tic; fprintf( 'vector: %dx%d ', size(I_A) );
    try
        M=hermite_triple_fast(I_A,I_A,I_A,'algorithm','vectorized1');
        toc;
        T(i,2)=toc;
    catch
        disp( 'Aborted' );
    end

end
save TS S T U


function comp_3p
T=[];
S=[];
U=[];

for i=1:15
    I_A=multiindex(3,i);
    U(i,:)=[size(I_A), prod(size(I_A))];
    
    disp(' ');
    
    tic; fprintf( 'sparse: %dx%d ', size(I_A) );
    try
        M=hermite_triple_fast(I_A,I_A,I_A,'algorithm','sparseb');
        toc;
        T(i,1)=toc;
        S(i,1)=nnz(M);
        S(i,2)=numel(M);
    catch
        disp( 'Aborted' );
    end

    tic; fprintf( 'vector: %dx%d ', size(I_A) );
    try
        M=hermite_triple_fast(I_A,I_A,I_A,'algorithm','vectorized1');
        toc;
        T(i,2)=toc;
    catch
        disp( 'Aborted' );
    end

end
save TS2 S T U

