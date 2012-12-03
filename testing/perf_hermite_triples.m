function perf_hermite_triples

% dont complain about growing error and exceptions caught without variable
% in this file
%#ok<*AGROW>
%#ok<*CTCH>

by_num

function by_deg
if ~exist('TS2', 'file')
    comp_timings(10, true)
end
load TS2
show(U,T,S)

function by_num
if ~exist('TS', 'file')
    comp_timings(10, false)
end
load TS
show(U,T,S)


function show(U,T,S)
%[U S T]
subplot(2,2,1)
regplot( U, 1, T, 1, 6)
subplot(2,2,2)
regplot( U, 3, T, 1, 6)
subplot(2,2,3)
regplot( S, 1, T, 1, 6)
subplot(2,2,4)
regplot( S, 2, T, 1, 6)

function r=regplot( A, i1, B, i2, s )
a=log10(A(s:end,i1));
b=log10(B(s:end,i2));
r=polyfit( a, b, 1);
plot( a, b, 'x', a, polyval(r,a), '-' );
r=r(1);


function comp_timings(maxn, by_degree)
T=[];
S=[];
U=[];

for i=1:maxn
    if by_degree
        I_A=multiindex(3,i);
    else
        I_A=multiindex(i,3);
    end
        
    U(i,:)=[size(I_A), numel(I_A)];
    
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
        hermite_triple_fast(I_A,I_A,I_A,'algorithm','vectorized1');
        toc;
        T(i,2)=toc;
    catch
        disp( 'Aborted' );
    end

end
if by_degree
    save TS2 S T U
else
    save TS S T U
end


