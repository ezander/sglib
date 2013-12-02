function I=multiindex_anisotropic(m,p,alpha)
% MULTIINDEX_ANISOTROPIC Short description of multiindex_anisotropic.
%   MULTIINDEX_ANISOTROPIC Long description of multiindex_anisotropic.
%
% Example (<a href="matlab:run_example multiindex_anisotropic">run</a>)
%   I=multiindex_anisotropic( 2, 13, [3, 2] )
%   m=sparse( I(:,1)+1, I(:,2)+1, ones( size(I,1), 1 ) );
%   subplot(2,2,1);
%   spy2(m,'face_color',[1 0.6 0.7],'edge_color','k');
%   axis image
%   set( gca, 'ydir', 'normal' );
%   subplot(2,2,2);
%   I=multiindex_anisotropic( 2, 10, [2, 1] )
%   m=sparse( I(:,1)+1, I(:,2)+1, ones( size(I,1), 1 ) );
%   spy2(m,'face_color',[.2 0.3 1.0],'edge_color','k');
%   axis image
%   set( gca, 'ydir', 'normal' );
%   I=multiindex_anisotropic( 2, 10, [4, 3] )
%   m=sparse( I(:,1)+1, I(:,2)+1, ones( size(I,1), 1 ) );
%   subplot(2,2,3);
%   spy2(m,'face_color',[0.3 0.85 0.3],'edge_color','k');
%   axis image
%   set( gca, 'ydir', 'normal' );
%   I=multiindex_anisotropic( 2, 6, [6, 1] )
%   m=sparse( I(:,1)+1, I(:,2)+1, ones( size(I,1), 1 ) );
%   subplot(2,2,4);
%   spy2(m,'face_color',[1 0.2 0.1],'edge_color','k');
%   axis image
%   set( gca, 'ydir', 'normal' );
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

%check_numeric( alpha, 'integer' );
%check_range( alpha, 1, inf, 'alpha', mfilename );

alpha=alpha(:);

I=multiindex(m,p);
amin=min(alpha);

ind=(I*alpha)<amin*p;
I=I(ind,:);
