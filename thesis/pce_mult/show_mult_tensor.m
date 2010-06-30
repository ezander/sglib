I=multiindex(10,1); 
I=multiindex(3,5); 
I=multiindex(3,7); name='comp_mult_tensor_3_7.eps';
I=multiindex(3,4,true,'full',true); name='full_mult_tensor_3_4.eps';

nnz(hermite_triple_fast(I,I,I));
M=hermite_triple_fast(I,I,I);

ind=find(M);

[i,j,k]=ind2sub(size(M),ind);
plot3( i,j,k,'.','MarkerSize', 2);
grid on;
axis equal;
T =[
    0.7826    0.6225         0   -0.7026
    -0.2729    0.3431    0.8988   -0.4845
    -0.5595    0.7034   -0.4384    8.8075
    0         0         0    1.0000];
view(T);
print( '-deps2c',  name )
