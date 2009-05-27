function spy2(A, varargin)
% SPY2 Replacement for the SPY function.
%   SPY2(A, VARARGIN) does the same as the builtin matlab SPY function
%   except that no symbols are drawn but contiguous rectangles (patches).
%   This has the advantage that scaling is better as the graphics are
%   resized.
%
% Options:
%   face_color ('b'): The color of the faces of the rectangle. For possible
%   values see here <a href="matlab:doc ColorSpec">ColorSpec</a>
%   edge_color ('none'): The color of the edges of the rectangle. Use 'none' if
%     no  edges should be drawn.
% 
% Example (<a href="matlab:run_example spy2">run</a>)
%     clf;
%     A=rand(30);
%     A(A<.7)=0;
%     subplot(2,2,1); spy(A);
%     subplot(2,2,2); spy2(A);
%     subplot(2,2,3); spy2(A,'face_color','g' );
%     subplot(2,2,4); spy2(A,'face_color','g','edge_color','k');
% 
% See also SPY, PATCH


%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin{:} );
[face_color,options]=get_option( options, 'face_color', 'b' );
[edge_color,options]=get_option( options, 'edge_color', 'none' );
check_unsupported_options( options, mfilename );


[x,y]=find(A);
X=[x,x+1,x+1,x,x]'-1/2;
Y=[y,y,y+1,y+1,y]'-1/2;
if ~ishold
    cla
end

patch( X, Y, face_color, 'EdgeColor', edge_color )
[m,n]=size(A);
ylim([0, m+1]);
xlim([0, n+1]);
set( gca, 'YDir', 'reverse' );
axis( 'square' );
grid( 'off' );
box( 'on' );
