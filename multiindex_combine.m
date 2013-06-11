function varargout=multiindex_combine( I_j, p, varargin )
% MULTIINDEX_COMBINE Combine multiindices from different sources.
%   VARARGOUT=MULTIINDEX_COMBINE( I_J, P ) combines the multiindices in the
%   cell array I_J so that they can be used as multiindices for random
%   fields from different independent sources (see example and rational).
%   If you supply P you can tell MULTIINDEX_COMBINE to create also
%   multiindex set for the output field up to order P. If P is -1 then the
%   order is the highest order found in the input fields. If you don't
%   supply P, no multiindex set is generated.
%
% Rational
%   If you have multiple independent random fields as input data to your
%   stochastic problem, you usually create the multiindices independently
%   with e.g. MULTIINDEX. Now, for the application the basic independent
%   random variables are identified by their column index in the multiindex
%   set. Thus the underlying random variables for different and independent
%   input fields would relate to the same basic random variables, and thus
%   not be independent (and after all, that'd be utter nonsense). Thus you
%   can user MULTIINDEX_COMBINE to just shift (column) index positions so
%   that each input field has its own independent set of basic random
%   variables, because they don't share column indices.
%   The multiindex sets can on the other not be combined into just one big
%   set because other expansion (or rather, the coefficients in those
%   expansions) refer to exactly one multiindex (in the input random field)
%   by its row index. Of course, this could be changed and all methods
%   could use the same large multiindex set, but this would require
%   remapping other expansion (making them larger by the way), making
%   things even more difficult and thus introducing more sources of error.
%
% Example (<a href="matlab:run_example multiindex_combine">run</a>)
%   I_f=multiindex(2,3)
%   I_k=multiindex(3,2)
%   I_g=multiindex(2,2)
%   [I_f,I_k,I_g,I_u]=multiindex_combine({I_f,I_k,I_g},-1);
%   disp(full(I_f)); disp(full(I_k)); disp(full(I_g)); disp(size(I_u))
%
% See also MULTIINDEX, MULTIINDEX_ORDER

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[use_sparse,options]=get_option( options, 'use_sparse', 'auto' );
[lex_ordering,options]=get_option( options, 'lex_ordering', false );
check_unsupported_options( options, mfilename );

if ischar(use_sparse) && strcmp( use_sparse, 'auto' )
    use_sparse=all( cellfun( @issparse, I_j) );
end

m=numel(I_j);
% preallocate output cell array
if nargin<2
    varargout=cell(1,m);
else
    varargout=cell(1,m+1);
end

I_j = multiindex_extend(I_j);
varargout(1:m) = I_j;


% create a matrix for the output random field
if nargin>=2
    n_vars = size(I_j{1}, 2);
    if p==-1
        for i=1:m
            p=max(p,max(sum(I_j{i},2)));
            p=full(p); % necessary if I_j is sparse
        end
    end
    varargout{m+1}=multiindex( n_vars, p, 'use_sparse', use_sparse, 'lex_ordering', lex_ordering );
end


function I_j = multiindex_extend(I_j)
% determine the combined number of random vars
m=numel(I_j);
n_vars=0;
for i=1:m
    n_vars=n_vars+size(I_j{i},2);
end


% set the number of random vars that should be insert before and after the
% current index set
n_pre=0;
n_post=n_vars;

for i=1:m
    I_curr=I_j{i};
    n_curr=size(I_curr,2);
    m_curr=size(I_curr,1);

    n_post=n_post-n_curr;
    if issparse(I_curr)
        % if sparse we can just shift column numbers and set the matrix
        % size to the new values
        [rows,cols,vals] = find(I_curr);
        I_j{i}=sparse(rows,cols+n_pre,vals,m_curr,n_vars);
    else
        % for full matrices we have to append and prepend zero matrices
        I_j{i}=[zeros(m_curr,n_pre), I_curr, zeros(m_curr,n_post)];
    end
    n_pre=n_pre+n_curr;
end


