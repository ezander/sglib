function fak=factorial( n )

m=max(n(:));
fak_n=[1 cumprod(1:m) ];
fak=reshape( fak_n( n+1 ), size(n));
