function test_als

n1=50;
n2=70;
n3=80;
k=3;
A1=rand(n1,k);
A2=rand(n2,k);
A3=rand(n3,k);


A=tensor_to_array( {A1,A2,A3} );

B=tensor_to_array( {A1, khatriraorev( A2, A3 )} );
assert_equals( A(:), B(:) )

B=tensor_to_array( {khatriraorev( A1, A2 ), A3} );
assert_equals( A(:), B(:) )

A=shiftdim(A,1);
B=tensor_to_array( {A2,A3,A1} );
assert_equals( A(:), B(:) );

warning( 'off', 'MATLAB:rankDeficientMatrix' );
B=als( A, k+2, 100 );
warning( 'on', 'MATLAB:rankDeficientMatrix' );
fprintf( '%g\n', gvector_error(A,B,'relerr',true));

function B=als( A, k, N )

[n1,n2,n3]=size(A);
B1=rand(n1,k);
B2=rand(n2,k);
B3=rand(n3,k);

N1=round(N/10);
for i=1:N
    B=tensor_to_array( {B1,B2,B3} );
    if mod(i-1,N1)==0
        fprintf( '%4d: %g\n', i-1, gvector_error(A,B,'relerr',true));
    end
    
    S1=reshape( shiftdim(A,0), n1, [] );
    o1=gvector_norm( S1-B1*khatriraorev( B2, B3 )');
    %B1=S1'\khatriraorev( B2, B3 );
    B1=(khatriraorev( B2, B3 )\S1')';
    o2=gvector_norm( S1-B1*khatriraorev( B2, B3 )');
    %fprintf( '%g=>%g\n', o1,o2);

    S2=reshape( shiftdim(A,1), n2, [] );
    B2=(khatriraorev( B3, B1 )\S2')';

    S3=reshape( shiftdim(A,2), n3, [] );
    B3=(khatriraorev( B1, B2 )\S3')';

end
B=tensor_to_array( {B1,B2,B3} );




