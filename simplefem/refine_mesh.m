function [newpos,newels]=refine_mesh( pos, els )

npos=size(pos,2);
nels=size(els,2);

% extract edges and which edges belongs to which element
edges=[ els([1;2],:), els([2;3],:), els([3;1],:)];
eltoedge=reshape(1:(3*nels),[],3)';
% should hold: els==reshape( edges( 1, eltoedge ), 3, [] )

% extract unique edges and create new points on them (also keep relation to
% original edges in 'from')
uedges=sort(edges,1);
[uedges,to,from]=unique( uedges', 'rows' );
uedges=uedges';
addpos=1/2*(pos(:, uedges(1, :)) + pos(:, uedges(2, :)));
newpos=[pos, addpos];

% define new elements using 'nonunique' points
nels=npos+[eltoedge(1,:); eltoedge(2,:); eltoedge(3,:)];
nels=[nels, [edges( 1, eltoedge(1,:) ); npos+eltoedge(1,:); npos+eltoedge(3,:)]];
nels=[nels, [edges( 1, eltoedge(2,:) ); npos+eltoedge(2,:); npos+eltoedge(1,:)]];
nels=[nels, [edges( 1, eltoedge(3,:) ); npos+eltoedge(3,:); npos+eltoedge(2,:)]];

% create mapping from 'from' index to map to unique points
map=[1:npos npos+from'];
newels=map(nels);

