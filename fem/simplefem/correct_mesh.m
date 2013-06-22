function [pos,els]=correct_mesh( pos, els )

ind=unique(sort(els(:)));
dist=size(ind,1);
if any(ind~=(1:dist)')
    old2new(ind)=1:dist;
    els=old2new(els);
    pos=pos(:,ind);
end

T=size(els,2);

for t=1:T
    nodes=els(:,t);
    coords=pos(:,nodes);

    J=[ones(1,size(coords,2)); coords];
    if det(J)<0
        els([1,2],t)=els([2,1],t);
    end
end

