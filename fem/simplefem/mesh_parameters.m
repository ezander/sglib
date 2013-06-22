function [hmin, hmax, hmean]=mesh_paramters( pos, els )

d=size(pos,1);
n=size(els,1);
els=[els; els(1,:)];
%p=pos(:,els);
p=reshape( pos(:,els), [d, size(els)]);
p=p(:,1:n,:)-p(:,2:n+1,:);
p=p(:,:);
h=sqrt(sum(p.^2,1));
hmin=min(h);
hmax=max(h);
hmean=mean(h);
