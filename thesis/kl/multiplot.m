function h=multiplot( mh, i, j )
[m,n]=mh{1}{:};
if nargin<3
    j=1;
end
k=j+n*(i-1);
h=subplot(m,n,k); hold all;
