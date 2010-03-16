function P=point_projector( pos, els, x )
% POINT_PROJECTOR Short description of point_projector.
%   POINT_PROJECTOR Long description of point_projector.
%
% Example (<a href="matlab:run_example point_projector">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

n=size(x,2);
d=size(pos,1);
m=size(pos,2);

P=sparse(m,n);
for i=1:n
    switch d
        case 1
            [posind,val]=point_projector_1d( pos, els, x(:,i) );
            P(posind,i)=val; %#ok<SPRIX>
        case 2
            [posind,val]=point_projector_2d( pos, els, x(:,i) );
            P(posind,i)=val; %#ok<SPRIX>
        otherwise
            error( 'point_projector:wrong_param', 'Not implemented or pos is transposed' );
    end
end

function [posind,val]=point_projector_1d( pos, els, x )
elsind=find(pos(els(1,:))<=x & pos(els(2,:))>=x,1,'first');
posind=reshape( els(:,elsind), 1, []);
p=pos(:,posind);
val=[p; ones(1,size(p,2))]\[x;1];


function [posind,val]=point_projector_2d( pos, els, x )
edges=[ els([1;2],:), els([2;3],:), els([3;1],:)];
p1=pos(:,edges(1,:));
p2=pos(:,edges(2,:));
px=repmat(x,1,size(edges,2));
d1=p2-p1;
d2=px-p1;
s=d1(1,:).*d2(2,:)-d1(2,:).*d2(1,:);
n=size(els,2);
s2=[s(:,(0*n+1):(1*n)); s(:,(1*n+1):(2*n)); s(:,(2*n+1):(3*n)) ];
elsind=find(all(s2>=0,1),1,'first');

posind=reshape( els(:,elsind), 1, []);
p=pos(:,posind);
val=[p; ones(1,size(p,2))]\[x;1];
