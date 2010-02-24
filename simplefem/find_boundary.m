function bnd=find_boundary( els, points_only )

d=size(els,1)-1;
switch d
    case 1
        bnd=find_boundary_1d( els );
    case 2
        bnd=find_boundary_2d( els, points_only );
    otherwise
        error('simplefem:find_boundary:param_error', 'Unsupported dimension: %d. Maybe you have to pass your position vector transposed?', d);
end


function bnd=find_boundary_1d( els )
edgs=[els(1,:), els(2,:)];
bnd=find_boundary_from_edges( edgs );

function bnd=find_boundary_2d( els, points_only )
edgs=[els([1;2],:), els([2,3],:), els([3;1],:)];
bnd=find_boundary_from_edges( edgs );
if points_only
    bnd=unique( bnd(:) )';
end

function bnd=find_boundary_from_edges( edgs )
edgs=sort(edgs,1);
edgs=sortrows(edgs')';
asnext=all(edgs(:,1:end-1)==edgs(:,2:end),1);
bndind=~([0,asnext]|[asnext,0]);
bnd=edgs(:,bndind);
