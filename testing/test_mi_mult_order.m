function x
p=3;
I1=multiindex(1,p);
I=multiindex(1,4*p);

a1=rand(1,p+1)/10;
a=[a1, zeros(1,3*p)];

xi=0.2;
pce_evaluate( a1, I1, xi )
pce_evaluate( a, I, xi )

[d,d2]=power4(a,I);
%norm(d-d2)
de=d;
pce_error_est(d2,I,de,I)

[d,d2]=power4(a1,I1);
pce_error_est(d,I1,de,I)
pce_error_est(d2,I1,de,I)
[mu,var]=pce_moments(de,I)

% pce_evaluate( de, I, xi )
% pce_evaluate( d, I1, xi )
% pce_evaluate( d2, I1, xi )



function [d,d2]=power4( a, I )
b=pce_multiply( a, I, a, I, I );
c=pce_multiply( b, I, a, I, I );
d=pce_multiply( c, I, a, I, I );
d2=pce_multiply( b, I, b, I, I );
