function [int,w]=integrate_nd(func, rule_func, m, p, varargin )
% INTEGRATE_ND Integrate a multivariate function.
%    INT=INTEGRATE_ND(FUNC, RULE_FUNC, M, P, OPTIONS ) integrates the function
%    FUNC using Smolyak quadrature based on the 1d integration rule
%    RULE_FUNC in M variables using P stages. For examples please refer to
%    the unit test (UNITTEST_INTEGRATE_ND). Instead of Smolyak also full
%    tensor product quadrature can be used (see options section).
%
%    [X,W]=INTEGRATE_ND([], RULE_FUNC, M, P, OPTIONS ) returns the
%    integration points and weights for the given high-dimensional
%    integration rule.
%
% Options:
%   vectorized: {true}, false
%      If FUNC accepts only one point at a time set this to false. This is,
%      however, slower. If set to true, which is the default, you have to
%      make sure that your code returns values dimensionally correct (see
%      also 'transposed' option). 
%   transposed: true, {false}
%      Set to true, if your code takes and returns row vectors instead of
%      column vectors.
%   grid: {'smolyak'}, 'tensor'
%      Specifiy grid method to use.
%   grid_func: []
%      If specified takes priority over the 'grid' option. Any function
%      returning a valid multivariate integration grid and adhering to the
%      interface of SMOLYAK_GRID and FULL_TENSOR_GRID can be used.
%
% Example (<a href="matlab:run_example integrate_nd">run</a>)
%    % Integrate EXP(X+Y+Z) on R^3 with Gaussian measure using a full
%    % tensor product grid based on Gauss Hermite quadrature of order 8
%    % (i.e. exact up to degree 15)
%    integrate_nd( @(x)(exp( sum(x,1)/sqrt(3) )), @gauss_hermite_rule, 3, 8, 'grid', 'tensor' )
%    % this is the analytical result for the former integral
%    exp(1/2)
%
% See also INTEGRATE_1D, GAUSS_HERMITE_RULE, GAUSS_LEGENDRE_RULE, SMOLYAK_GRID

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


options=varargin2options( varargin );
[vectorized,options]=get_option( options, 'vectorized', true );
[transposed,options]=get_option( options, 'transposed', false );
[grid,options]=get_option( options, 'grid', 'smolyak' );
[grid_func,options]=get_option( options, 'grid', [] );
check_unsupported_options( options, mfilename );

if isempty(grid_func)
    switch grid
        case 'smolyak'
            grid_func=@smolyak_grid;
        case {'tensor', 'full_tensor'}
            grid_func=@full_tensor_grid;
        otherwise
            error( 'integrate:grid', 'unknown grid type: %s', grid );
    end
end

% get pos and weights and make sure they are in the right shape
[xd,wd]=funcall(grid_func, m, p, rule_func );

% if no functions is specified just return points and weights as 
% cell array
if isempty(func)
    if nargout<2
        int = {xd, wd};
    else
        int = xd;
        w = wd;
    end
    return
end

% integrate with the computed points and weights
if vectorized
    if ~transposed
        int=funcall(func,xd)*wd;
    else
        int=wd'*funcall(func,xd');
    end
else
    int=wd(1)*funcall(func,xd(:,1));
    for i=2:length(wd)
        int=int+wd(i)*funcall(func,xd(:,i));
    end
    if transposed
        int=permute( int, [2 1] );
    end
end
