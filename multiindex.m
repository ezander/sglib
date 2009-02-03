function I_mp=multiindex(m,p,combine,varargin)
% MULTIINDEX Generate a table of multiindices (block-scheme).
%   I_MP=MULTIINDEX(M,P,COMBINE) generate a table of multiindices using 
%   the standard block scheme i.e. generating all multi-indices up to
%   degree P in all M (random) variables. (Limitation to certain
%   limiters/norms will be added later). If combine is not specified or
%   evaluates to true then the homogeneous multiindices will be combined 
%   into one large (sparse) array I_MP. Otherwise I_MP is a cell array
%   where I_MP{q+1} represents the multiindices with degree q.
%
% Example
%   % To generate the polynomial chaos for 2 random variables up to
%   % polynomial order 4 
%   I=multiindex(2,4);
%   disp(I);
%   % Get output as sparse array
%   I=multiindex(2,4,[],'use_sparse',true); 
%   disp(I); % convert from sparse
% 
%   % To generate the polynomial chaos for 5 random variables up to
%   % polynomial order 3, using only the homogeneous chaos of order 3 
%   I=multiindex(5,3,false); 
%   I3=full(I{3+1});
%   disp(I3)
%
% See also MULTIINDEX_ORDER, MULTIINDEX_COMBINE, MULTIINDEX_FACTORIAL

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

error( nargchk( 2, inf, nargin ) );

if nargin<3 || isempty(combine)
    combine=true;
end

options=varargin2options( varargin{:} );
[use_sparse,options]=get_option( options, 'use_sparse', false );
check_unsupported_options( options, mfilename );

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
    if use_sparse
        %I_kp{q+1}=sparse(1,1,q);
        I_kp{q+1}=sparse(q==0,0);
    else
        %I_kp{q+1}=q;
        I_kp{q+1}=zeros(q==0,0);
    end
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
        if use_sparse
            I_kp{q+1}=spalloc(count(q+1),k,nonzero(q+1));
        else
            I_kp{q+1}=zeros(count(q+1),k);
        end
    end

    for q=0:p
        % Copy indices from m-1 random vars in the new multiindex field to
        % the right position
        I_kp{q+1}( :, 1:end-1 ) = catmat(I_k1p{(q+1):-1:1});
        % Now fill the right most column such that I_kp{q+1} still has
        % homogeneous order q
        I_kp{q+1}(:,end)=q-sum(I_kp{q+1},2);
    end
end

if combine
    I_kp=catmat(I_kp{:});
end
I_mp=I_kp;


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
