function [xd,wd]=smolyak_grid( d, stages, oned_rule_func, varargin )
% SMOLYAK_GRID Return nodes weights for Smolyak quadrature.
%   [XD,WD] = SMOLYAK_GRID( D, STAGES, ONED_RULE_FUNC ) returns nodes XD(K,:)
%   and weights WD(K) for Smolyak quadrature. D is the dimension of the
%   problem, STAGES is the maximum number of stages in each dimension and
%   ONED_RULE_FUNC (read: 1D_RULE_FUNC) is a handle to a function returning
%   the 1d quadrature rules. ONED_RULE_FUNC must be of the signature
%   [X,W]=FUNC( P ) where P is the stage number and X and W are the
%   quadrature points and weights.
%
%   If you set STAGES to an empty array, ONED_RULE_FUNC can be a vertical
%   cell array of rule functions, one for each dimension. The number of
%   stages is implied by the length of the cell array.
%
% Options:
%   verbosity: 0
%      Shows statistics at the end of the run if verbosity > 0.
%   make_unique: {true}, false
%      Returns only unique points in XD. Needs additional sorting of XD and
%      adding up of weights in WD at the end, saves in the integration
%      however. (Note: I think this should always be true, left only as an
%      option for compatibility with old A. K. versions.)
%
% Example (<a href="matlab:run_example smolyak_grid">run</a>)
%   for rule={@gauss_hermite_rule, @gauss_legendre_rule, @clenshaw_curtis_nested}
%     for i=1:4
%       [xd,wd]=smolyak_grid( 2, 3+i, rule );
%       subplot(2,2,i);
%       plot(xd(1,:),xd(2,:),'*k')
%       subtitle( func2str( rule{1} ), 'interpreter', 'none' );
%     end
%     userwait
%     for i=1:4
%       [xd,wd]=smolyak_grid( 3, 3+i, rule );
%       subplot(2,2,i);
%       plot3(xd(1,:),xd(2,:),xd(3,:),'.k')
%       subtitle( func2str( rule{1} ), 'interpreter', 'none' );
%     end
%     userwait
%   end
%
% See also FULL_TENSOR_GRID

%   Andreas Keese, Elmar Zander
%   Copyright 2006, 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[verbosity,options]=get_option( options, 'verbosity', 0 );
[make_unique,options]=get_option( options, 'make_unique', true );
check_unsupported_options( options, mfilename );



% set dimension parameter as length of oned_rule_func if not specified
if isempty(d)
    d=size(oned_rule_func,1);
end

% Number of stages must be the same for all dimensions for Smolyak (thus scalar)
if length(stages)~=1
    error( 'Number of stages must be scalar for Smolyak.' );
end

% expand oned_rule_func to cell array of appropriate size
if ~iscell(oned_rule_func)
    oned_rule_func=repmat({oned_rule_func},d,1);
elseif length(oned_rule_func)==1
    oned_rule_func=repmat(oned_rule_func,d,1);
elseif length(oned_rule_func)~=d
    error( 'Dimension d doesn''t match that of the cell array of rules functions.' );
end



% For each dimension n obtain all quadrature formulas
% Q^{(n)}_1 \ldots Q^{(n)}_order
x1=cell(d, stages);
w1=cell(d, stages);
n1d=zeros(d, stages);

for k = 1:d
    for j = 1:stages
        [x1{k,j},w1{k,j}] = funcall( oned_rule_func{k}, j );
        n1d(k,j) = length(x1{k,j});
    end
end

% Construct Smolyak-nodes and weights based on the univariate
% quadrature formulas:
xd=[];
wd=[];

I=multiindex(d,stages-1,'combine', false);
I=cell2mat(I(max(0,stages-d)+1:end)')+1;
for i=1:size(I,1)

    alpha = I(i,:);

    tmp_x1 = cell(d,1);
    tmp_w1 = cell(d,1);
    for j=1:d
        alpha_j  = alpha(j);
        tmp_x1{j} = x1{j,alpha_j};
        tmp_w1{j} = w1{j,alpha_j};
    end
    [tmp_xd,tmp_wd]=tensor_mesh(tmp_x1,tmp_w1);

    alpha_sum = sum(alpha);
    factor=(-1)^(d+stages-1-alpha_sum) * nchoosek(d-1,alpha_sum-stages);

    xd=[xd,tmp_xd]; %#ok<AGROW>
    wd=[wd;factor*tmp_wd]; %#ok<AGROW>
end

if make_unique
    [xdt,i,j]=unique( xd', 'rows' ); %#ok<ASGLU>
    xd=xdt';
    wd=accumarray(j,wd);
end

if verbosity>0
    fprintf( 'Smolyak:\n')
    fprintf( 'type          = %s\n', func2str(oned_rule_func{1}))
    fprintf( 'dimension   d = %d\n', d)
    fprintf( 'order-index l = %d\n', stages)
    fprintf( 'S^N_l #points = %d\n', length(wd) );
end

