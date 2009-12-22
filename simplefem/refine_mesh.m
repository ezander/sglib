function [newels,newpos]=refine_mesh( els, pos )

edges=unique( [els(:,1) els(:,2); els(:,2) els(:,3); els(:,3) els(:,1)], 'rows' );

addpos=1/2*(pos(edges(:,1),:) + pos(edges(:,2),:));
newpos=[pos; addpos];
newels=delaunay( newpos(:,1), newpos(:,2) );
