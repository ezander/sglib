function bnd=find_boundary( els, points_only )
e=[els(:,1), els(:,2); els(:,1), els(:,3); els(:,2), els(:,3)];
e=sort(e,2);
e=sortrows(e);

asnext=all(e(1:end-1,:)==e(2:end,:),2);
bndind=~([0;asnext]|[asnext;0]);
bnd=e(bndind,:);
if points_only
    bnd=unique( bnd(:) );
end
