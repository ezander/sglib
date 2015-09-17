function spy2(A, varargin)
% SPY2 Replacement for the SPY function.
%   SPY2(A, VARARGIN) does the same as the builtin matlab SPY function
%   except that no symbols are drawn but contiguous rectangles (patches).
%   This has the advantage that scaling is better as the graphics are
%   resized.
%
% Options:
%   face_color: {'b'}
%     The color of the faces of the rectangle. For possible values see here
%     <a href="matlab:doc ColorSpec">ColorSpec</a>
%   edge_color: {'none'}
%     The color of the edges of the rectangle. Use 'none' if no  edges
%     should be drawn.
%   display:  {'nnz'}, 'density', 'none'
%     Display the statistics below the axis. 'nz' or 'nnz' means number of
%     nonzero element (matlab default). 'dens' or 'density' means nnz
%     divided by matrix size. 'none' means none with high probability.
%   min_rel_val: {0}
%     Minimum value that is considered to be non-zero relative to the
%     maximum absolute value contained in the matrix.
%   min_abs_val: {0}
%     Minimum value that is considered to be non-zero.
%   color_scale: {'none'}, 'log', 'linear'
%     'none' is the default behavior to show all non-zero elements in the
%     same color. 'log' gives a logarithmically scaled coloring to the
%     non-zero elements (see also log_range). 'lin' and 'linear'
%     respectively.
%   log_range: {10}, integer, 'auto'
%     Specify the log10 range for logarithmic coloring. A value of K means
%     all elements with a modulus less than max(abs(A))*10^-K will be
%     white.
%   lin_range: integer, {'auto'}
%     Specify the range for linear coloring. A value of K means
%     all elements with a modulus less than max(abs(A))-K will be
%     white.
%
% Example (<a href="matlab:run_example spy2">run</a>)
%     clf;
%     A=rand(32);
%     A(A<.7)=0;
%     subplot(2,2,1); spy(A);
%     subplot(2,2,2); spy2(A);
%     subplot(2,2,3); spy2(A,'face_color','g', 'display', 'density' );
%     subplot(2,2,4); spy2(A,'face_color','g','edge_color','k');
%
% See also SPY, PATCH

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[display,options]=get_option( options, 'display', 'nnz' );
[face_color,options]=get_option( options, 'face_color', 'b' );
[edge_color,options]=get_option( options, 'edge_color', 'none' );
[min_rel_val,options]=get_option( options, 'min_rel_val', 0 );
[min_abs_val,options]=get_option( options, 'min_abs_val', 0 );
[color_scale,options]=get_option( options, 'color_scale', 'none' );
[log_range,options]=get_option( options, 'log_range', 10 );
[lin_range,options]=get_option( options, 'ling_range', 'auto' );
check_unsupported_options( options, mfilename );

% get index of nonzero elements
cmp = max(min_abs_val, max(abs(A(:)))*min_rel_val);
[x,y]=find(abs(A)>cmp);

% make sure x and y are row vectors (not true if dim(A,1)==1)
x=reshape(x,1,[]); y=reshape(y,1,[]);

% create arrays of rectangle vertices
h=1/2;
X=[x-h; x+h; x+h; x-h; x-h];
Y=[y-h; y-h; y+h; y+h; y-h];

% create color array if necessary
n=size(x,2);
switch color_scale
    case 'none'
        % nothing to do here (set C to 'blue', get's overwritten anyway)
        opts = {'EdgeColor', edge_color, 'FaceColor',face_color};
    case 'log'
        ind = sub2ind(size(A), x, y);
        v = log(abs(A(ind)))';
        max_v = max(v(:));
        if ischar(log_range) && strcmp(log_range, 'auto')
            min_v = min(v(:));
            scale = 1 / (max_v - min_v);
        else
            scale = 1 / (log(10) * log_range);
        end
        % alpha=1 denotes full face_color, alpha=0 denotes white
        alpha = scale * (v - max_v)  + 1;
        alpha(alpha<0) = 0;
        
        face_color = rgb(face_color);
        white = [1,1,1];
        opts = {'EdgeColor', edge_color, 'FaceColor', 'flat', 'FaceVertexCData', alpha*face_color + (1-alpha)*white};
        set(gcf, 'renderer', 'zbuffer');
    case {'lin', 'linear'}
        ind = sub2ind(size(A), x, y);
        v = abs(A(ind))';
        max_v = max(v(:));
        if ischar(lin_range) && strcmp(lin_range, 'auto')
            min_v = min(v(:));
            scale = 1 / (max_v - min_v);
        else
            scale = 1 / lin_range;
        end
        % alpha=1 denotes full face_color, alpha=0 denotes white
        alpha = scale * (v - max_v)  + 1;
        alpha(alpha<0) = 0;
        
        face_color = rgb(face_color);
        white = [1,1,1];
        opts = {'EdgeColor', edge_color, 'FaceColor', 'flat', 'FaceVertexCData', alpha*face_color + (1-alpha)*white};
        set(gcf, 'renderer', 'zbuffer');
    otherwise
        error('sglib:spy2', 'Unknown color_scale: %s', color_scale );
end

% now draw the patches (each column in X and Y represents one patch)
if ~ishold; cla; end
p=patch(X, Y, 'r');
set(p, opts{:});

% make it look nice
[m,n]=size(A);
set( gca, 'YDir', 'reverse' );
axis( 'image' );
ylim([0, m+1]);
xlim([0, n+1]);
grid( 'off' );
box( 'on' );

% print statistics in xlabel
switch display
    case 'nnz'
        xlabel( sprintf( 'nz = %d', nnz(A) ) );
    case 'density'
        xlabel( sprintf( 'dens = %.3g', nnz(A)/numel(A) ) );
    case 'none'
        % do nothing
    otherwise
        warning( 'spy2:UnknownOptionsValue', 'Unknown option value ''%s'' frgbor ''display''', display );
end
