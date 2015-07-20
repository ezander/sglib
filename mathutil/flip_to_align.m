function f=flip_to_align(f, g)
% FLIP_TO_ALIGN Flips functions to be positively aligned
%   F=FLIP_TO_ALIGN(F, G) flips the function F to be positively aligned
%   with G. Functions in F and G are considered to be represented by column
%   vector, i.e. function 1 in F would be F(:,1) and so on. The returned
%   have will have columns flipped as necessary, such that the inner
%   products SUM(F(:,i).*G(:,i)) will all be positive. This is useful when
%   comparing e.g. eigenfunctions computed by different methods, because
%   the sign here is usually not unique.
%
% Example (<a href="matlab:run_example flip_to_align">run</a>)
%     N = 40;
%     X = tridiagonal(N, 2, -1, -1);
%     
%     [U,D1] = eig(X);
%     [V,D2] = eigs(X, 5, 'sa');
%     multiplot_init(1,2);
%     multiplot;
%     h=plot(1:N, U(:,1:5), 'k-', 1:N, V(:,1:5), 'r-.');
%     title('Unflipped'); legend(h([1,6]), {'eig', 'eigs'});
%     
%     multiplot;
%     V = flip_to_align(V, U);
%     h=plot(1:N, U(:,1:5), 'k-', 1:N, V(:,1:5), 'r-.');
%     title('Flipped'); legend(h([1,6]), {'eig', 'eigs'});
%
% See also

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% Determine maximum number of functions in both F and G
n = min(size(f,2), size(g,2));

% Determines whether each of the 1 to n functions are positively aligned by
% computing their pairwise inner products <f_i, g_i>
factor=sign(sum(g(:,1:n).*f(:,1:n),1));

% Flips the not positively aligned functions
ind=factor==-1;
f(:,ind) = -f(:,ind);
