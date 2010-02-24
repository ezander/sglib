function [newpos,newels]=refine_mesh( pos, els )

edges=[ els([1;2],:), els([2;3],:), els([3;1],:)];
edges=unique( edges', 'rows' )';

addpos=1/2*(pos(:, edges(1, :)) + pos(:, edges(2, :)));
newpos=[pos, addpos];
newels=delaunay( newpos(1, :), newpos(2, :) )';
