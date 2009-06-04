function [newels,newpos]=refine_mesh( els, pos, method )

warning( 'refine_mesh:NotConvex', 'refine_mesh does not work correctly for nonconvex meshes!' );
% TODO: fix for nonconvex meshes

if nargin<3
    method='edgebased';
end

switch method
    case 'centered'
        [newels,newpos]=refine_centered( els, pos );
    case 'edgebased'
        [newels,newpos]=refine_edgebased( els, pos );
    otherwise
        error( 'Unknown refinement method: %s', method );
end

function [newels,newpos]=refine_edgebased( els, pos )

edges=unique( [els(:,1) els(:,2); els(:,2) els(:,3); els(:,3) els(:,1)], 'rows' );

addpos=1/2*(pos(edges(:,1),:) + pos(edges(:,2),:));
newpos=[pos; addpos];
newels=delaunay( newpos(:,1), newpos(:,2) );

% function [newels,newpos]=refine_edgebased2( els, pos )
% newpreels=[oldels max(els(:))+oldmesh.faces.edges];
% 
% newcoords=[oldcoords; addcoords];
% newnodes=[ 
%     newprenodes(:,6) newprenodes(:,1) newprenodes(:,4)
%     newprenodes(:,4) newprenodes(:,2) newprenodes(:,5)
%     newprenodes(:,5) newprenodes(:,3) newprenodes(:,6)
%     newprenodes(:,6) newprenodes(:,4) newprenodes(:,5)
%     ];



% function [newnodes,newcoords]=centeredRefinement( oldmesh )
% oldcoords=oldmesh.nodes.coords;
% oldnodes=oldmesh.faces.nodes;
% addcoords=1/3*(oldcoords(oldnodes(:,1),:) + oldcoords(oldnodes(:,2),:) + oldcoords(oldnodes(:,3),:));
% 
% newprenodes=[oldnodes size(oldcoords,1)+(1:size(addcoords,1))'];
% newcoords=[oldcoords; addcoords];
% newnodes=[ 
%     newprenodes(:,1) newprenodes(:,2) newprenodes(:,4)
%     newprenodes(:,2) newprenodes(:,3) newprenodes(:,4)
%     newprenodes(:,3) newprenodes(:,1) newprenodes(:,4)
%     ];
% 
