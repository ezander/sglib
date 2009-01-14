function [els,pos]=correct_mesh( els, pos )

ind=unique(sort(els(:)));
dist=size(ind,1);
if any(ind~=(1:dist)')
    old2new(ind)=1:dist;
    els=old2new(els);
    pos=pos(ind,:);
end

T=size(els,1);

for t=1:T
    nodes=els(t,:);
    coords=pos(nodes,:);
    
    J=[ones(size(coords,1),1) coords];
    if det(J)<0
        els(t,[1,2])=els(t,[2,1]);
    end
end

