function h=multiplot( mh, i, j )

persistent lmh li lj

if nargin<3 
    j=[];
end

if nargin<1
    mh=lmh;
end
if nargin<2
    i=li; j=lj;
    i=i+1;
    if i>size(mh,1); i=1; j=j+1; end
    if j>size(mh,2); j=1; end
end
lmh=mh;
li=i; lj=j;


if isempty(j)
    h=mh(i);
else
    h=mh(i,j);
end
set( gcf, 'CurrentAxes', h );
drawnow;

if nargout==0
    clear('h');
end
%[m,n]=size(mh);
%k=j+n*(i-1);
%h=subplot(m,n,k); hold all;
