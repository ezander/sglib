function I_mp=multiindex(m,p,varargin)
% MULTIINDEX Generate a table of multiindices.
%   I_MP=MULTIINDEX(M,P,OPTIONS) generates a table of multiindices up to
%   degree P in all M (random) variables.
%
% Note: from sglib version 0.9.3 on the third parameter COMBINE has been
%   removed and changed into an option. The method of passing the optional
%   COMBINE parameter was not compatible anymore with the newer 'varargin'
%   system of optional arguments.
%
% Options:
%   use_sparse: true, {false}
%     Return the result as a sparse array.
%   ordering: {'degree'}, 'lexicographical', 'lex', 'uqtoolkit', 'uqtk',
%     'random'
%     Specifies the ordering of the multiindex set returned. 'lex' and
%     'lexicographical' are the same and return the set in lexicographical
%     order. 'degree' and 'uqtoolkit' return the set ordered by degree,
%     where the second tries to be compatible with the UQToolkit for
%     complete polynomials. 'random' makes a random shuffling for testing
%     purposes.
%   lex_ordering: true, {false}
%     Obsolete. Use ordering='lex' instead!
%   combine: {true}, false
%     When true (default) the homogeneous multiindices will be combined
%     into one large array. Otherwise the return value I_MP is a cell array
%     where I_MP{q+1} represents the multiindices with degree q.
%   full: true, {false}
%     Return the full tensor product multiindex set.
%
% Example (<a href="matlab:run_example multiindex">run</a>)
%   % To generate the polynomial chaos for 2 random variables up to
%   % polynomial order 4
%   I=multiindex(2,4);
%   disp(I);
%   % Get output as sparse array
%   I=multiindex(2,4,'use_sparse',true);
%   disp(I); % convert from sparse
%
%   % To generate the polynomial chaos for 5 random variables up to
%   % polynomial order 3, using only the homogeneous chaos of order 3
%   I=multiindex(5,3,'combine', false);
%   I3=full(I{3+1});
%   disp(I3)
%
%   % Generate multiindices with ordering as in UQToolkit and compare to 
%   % standard sglib ordering
%   Iuq=multiindex(3,2,'ordering', 'uqtoolkit');
%   Isg=multiindex(3,2);
%   fprintf('uqtk    sglib\n')
%   fprintf('%d %d %d   %d %d %d\n', [Iuq, Isg]')
%
% See also MULTIINDEX_ORDER, MULTIINDEX_COMBINE, MULTIINDEX_FACTORIAL

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

error( nargchk( 2, inf, nargin ) );

if length(varargin)>=1 && isempty(varargin{1})
    error('sglib:obsolete', 'You are probably using the old interface of the multiindex function, which has changed as of version 0.9.3. Please remove [] as third argument.');
end

options=varargin2options( varargin );
[use_sparse,options]=get_option( options, 'use_sparse', false );
[lex_ordering,options]=get_option( options, 'lex_ordering', false );
[ordering,options]=get_option( options, 'ordering', 'degree' );
[combine,options]=get_option( options, 'combine', true );
[full,options]=get_option( options, 'full', false );
check_unsupported_options( options, mfilename );

rand_ordering = false;
switch ordering
    case {'lex','lexicographical'}
        std_ordering = true; % doesn't really matter
        lex_ordering = true;
    case 'degree'
        std_ordering = true;
        % leave lex_ordering as it is
    case {'uqtoolkit', 'uqtk'}
        std_ordering = false;
        % leave lex_ordering as it is
    case 'random'
        std_ordering = true;
        lex_ordering = false;
        rand_ordering = true;
    otherwise
        error('sglib:multiindex', 'unknown ordering: %s', std_ordering);
end

if full
    I_mp=multiindex_full(m, p, use_sparse);
else
    I_mp=multiindex_complete(m, p, std_ordering, use_sparse);
end

if combine
    I_mp=cell2mat( I_mp(:) );
    if lex_ordering
        I_mp=sortrows(I_mp,m:-1:1);
    elseif rand_ordering
        I_mp=shuffle_rows(I_mp);
    end
elseif lex_ordering
    for q=0:p
        I_mp{q+1}=sortrows(I_mp{q+1},m:-1:1);
    end
elseif rand_ordering
    for q=0:p
        I_mp{q+1}=shuffle_rows(I_mp{q+1});
    end
end


function I_kp=multiindex_full(m, p, use_sparse)
I_kp=cell(1,m*p+1);
for q=0:m*p
    I_kp{q+1}=array_alloc(q==0, 0, use_sparse);
end

% Now iterate over the number of random variables.
for k=1:m
    % Backup the old multiindex set for later use.
    I_k1p=I_kp;

    for q=0:k*p
        I_kp{q+1}=array_alloc(0, k, use_sparse);
    end
    for q=0:(k-1)*p
        for r=0:p
            I_kp{q+r+1}=[I_kp{q+r+1}; [I_k1p{q+1}, r*ones(size(I_k1p{q+1},1),1)]];
        end
    end
end


function I_kp=multiindex_complete(m, p, std_ordering, use_sparse)
% The (old) idea of the algorithm is the following:
% We do a recursion on the number of random variables, not on the order (in
% my opinion its easier and faster that way). For just one random variable
% the multiindices are then trivial (0..p). For m+1 random variables we
% take the result from m random variables, which are stored by order, and
% for each order of the new set take all sets from m with lower order and
% add the remaining difference as last column. At the end we combine all
% bins which contain multiindices of homogeneous order into one large set.
% An advantage of this approach, besides its simplicity, is that large
% parts can be vectorized, and it runs pretty fast even for big sets.
%
% This has now been changed (more or less trivially) to a non-recursive
% algorithm. We just start with one random variable, create the
% multiindex set, and then iteratively build the multiindex sets for one
% more random variable each time. (BTW: the reason for this change was that
% for large number of random variable, i.e. about 100 or more, the matlab stack
% was exhausted by the recursive algorithm).

% Note: algorithm has been changed to start from m=0
% Start with one random variable. Create a cell array like this
%   {[0],[1],[2],...,[p]}
% Since we have only one random variable (m=1), in each cell i there is
% just one monomial of homogeneous order q=i-1
I_kp=cell(1,p+1);
for q=0:p
    I_kp{q+1}=array_alloc(q==0, 0, use_sparse);
end

% Now iterate over the number of random variables.
for k=1:m
    % Backup the old multiindex set for later use.
    I_k1p=I_kp;

    % Get number of nonzero elements and number for multiindex set I_mp
    % nonzero and count are arrays that contain the respective values
    % indexed by order of the homogeneous indices (or polynomials). Then
    % use this information to allocate (sparse) arrays of the right size.
    [count,nonzero]=multiindex_stats(k,p);
    I_kp=cell(1,p+1);
    for q=0:p
        I_kp{q+1}=array_alloc(count(q+1), k, use_sparse, nonzero(q+1));
    end

    for q=0:p
        if std_ordering
            % Copy indices from m-1 random vars in the new multiindex field to
            % the position 1:m-1
            I_kp{q+1}( :, 1:end-1 ) = catmat(I_k1p{(q+1):-1:1});
            % Now fill the rightmost column (m) such that I_kp{q+1} still has
            % homogeneous order q
            I_kp{q+1}(:,end)=q-sum(I_kp{q+1},2);
        else
            % Copy indices from m-1 random vars in the new multiindex field to
            % the position 2:m
            I_kp{q+1}( :, 2:end ) = catmat(I_k1p{1:(q+1)});
            % Now fill the leftmost column such that I_kp{q+1} still has
            % homogeneous order q
            I_kp{q+1}(:,1)=q-sum(I_kp{q+1},2);
        end
    end
end

function [count,nonzero]=multiindex_stats(m,p)
% MULTIINDEX_STATS Compute number of multiindices and of non-zero exponents.
count=ones(1,p+1);
nonzero=[0 ones(1,p)];

for k=2:m
    for q=p:-1:0
        count(q+1)=sum(count(1:(q+1)));
        nonzero(q+1)=sum(nonzero(1:(q+1))) + sum(count(1:q));
    end
end


function A=catmat( varargin )
% CATMAT Concatenate multiindices from a cell array into one.

% Due to some stupidity one side of the Mathworks CAT does not work if only
% one array if passed (for CAT could just return the array as it is...). So
% we have to do that here ourselves. Given, if you explicitly call CAT with
% just one argument that would not make sense, but if your code shall be
% oblivious as to the number of arrays you're processing it does indeed.
if length(varargin)==1
    A=varargin{1};
else
    A=cat(1,varargin{:});
end

% workaround for an octave bug
if issparse(varargin{1}) && ~issparse(A)
    A=sparse(A);
end

function A = array_alloc(m, n, use_sparse, nnz)
% ARRAY_ALLOC Allocates a full or sparse array depending on a parameter.
if use_sparse
    if nargin<4
        A = sparse(m, n);
    else
        A = spalloc(m, n, nnz);
    end
else
    A=zeros(m, n);
end

function I=shuffle_rows(I)
M=size(I,1);
I=I(randperm(M),:);
