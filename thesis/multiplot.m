function h=multiplot( mh, i, j )
if nargin<3 || isempty(j)
    h=mh(i);
else
    h=mh(i,j);
end
set( gcf, 'CurrentAxes', h );
%[m,n]=size(mh);
%k=j+n*(i-1);
%h=subplot(m,n,k); hold all;
