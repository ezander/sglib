function plot_field_contour( pos, els, u, varargin )
% PLOT_FIELD_CONTOUR Plots a field given on a triangular mesh.
%   PLOT_FIELD_CONTOUR( POS, ELS, U, VARARGIN ) plots the field given in U on the
%   nodes given in POS performing interpolation on the triangles given in
%   ELS. Certain formatting options can be specified in the remaining
%   arguments:
%
%
% Example (<a href="matlab:run_example plot_field_contour">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

check_boolean( size(els,1)==3, 'elements must be triangles (size(els,1)==3)', mfilename );
check_range( size(pos,1), 2, 2, 'sizeof(pos,1)', mfilename );
check_boolean( size(pos,2)==size(u,1), 'number of points must equal number of values (size(u,1)==size(pos,2))', mfilename );

orig_pos=pos;
orig_els=els;
pos=pos';
els=els';

options=varargin2options( varargin );
[zpos,options]=get_option( options, 'zpos', 'min' );
[color,options]=get_option( options, 'color', 'auto' );
[bnd_zpos,options]=get_option( options, 'bnd_zpos', 'same' );
[bnd_color,options]=get_option( options, 'bnd_color', 'k' );
check_unsupported_options( options, mfilename );

zmin=min(u);
zmax=max(u);
zran=zmax-zmin;
nlev=10;
zlev=linspace( zmin+zran/(2*nlev+2), zmax-zran/(2*nlev+2),nlev);
X=pos(:,1);
Y=pos(:,2);

for i=1:nlev
    %lt=u<zlev(i);
    %gt=u>zlev(i);
    %u(els)<zlev(i)
    for j=1:3
        alpha(:,j)=(zlev(i)-u(els(:,j)))./(u(els(:,mod(j,3)+1))-u(els(:,j)));
    end
    K=abs(alpha)<1 & alpha>0;
    ind=sum(K,2)==2;
    %Z1=u(els(ind,[1,2,3,1]));
    %Z2=Z1(:,1:3)+alpha(ind,:).*(Z1(:,2:4)-Z1(:,1:3));
    X1=X(els(ind,[1,2,3,1]));
    X2=X1(:,1:3)+alpha(ind,:).*(X1(:,2:4)-X1(:,1:3));
    Y1=Y(els(ind,[1,2,3,1]));
    Y2=Y1(:,1:3)+alpha(ind,:).*(Y1(:,2:4)-Y1(:,1:3));
    [c,r]=find(K(ind,:)');
    c1=c(1:2:end);
    r1=r(1:2:end);
    c2=c(2:2:end);
    r2=r(2:2:end);
    np=size(X2,1);

    PP=nan*ones(np*3,3);
    PP(1:3:end,1)=X2(r1+(c1-1)*np);
    PP(2:3:end,1)=X2(r2+(c2-1)*np);
    PP(1:3:end,2)=Y2(r1+(c1-1)*np);
    PP(2:3:end,2)=Y2(r2+(c2-1)*np);
    if ischar(zpos)
        switch zpos
            case 'min'
                Z=zmin;
            case 'z'
                Z=zlev(i);
        end
    else
        Z=zpos;
    end
    PP(1:3:end,3)=Z;
    PP(2:3:end,3)=Z;
    if strcmp(color,'auto')
        cm=colormap;
        cind=round(1+(i-1)/(nlev-1)*size(colormap,1));
        cind=max(1,min(size(colormap,1),cind));
        c=cm(cind,:);
    else
        c=color;
    end
    line( PP(:,1), PP(:,2), PP(:,3), 'color', c);
     %'Parent',ax,...
     %       'color',contc,'Erasemode','normal');

end


pos=orig_pos;
els=orig_els;
if strcmp( bnd_zpos, 'same' )
    bnd_zpos=Z;
end
plot_boundary( pos, els, 'zpos', bnd_zpos, 'color', bnd_color );

