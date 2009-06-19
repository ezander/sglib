function bsxfun
A=ones(4,5);
B=1:5;
Xbsxfun( @plus, A, B )
A=(1:4)'
Xbsxfun( @times, A, B )

B=(1:5)';
A=ones(5,3,3);
Xbsxfun( @plus, A, B )


function C=Xbsxfun( fun, A, B )
n=max(ndims(A),ndims(B));
sa=size(A);
sb=size(B);
sa=[sa ones(1,n-length(sa))];
sb=[sb ones(1,n-length(sb))];
oa=sa==1;
ob=sb==1;
ra=ones(1,n);
rb=ones(1,n);
rb(ob)=sa(ob);
ra(oa)=sb(oa);
C=fun( repmat( A, ra ), repmat( B, rb ) );
