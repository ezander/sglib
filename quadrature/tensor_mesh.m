function [xd,wd] = tensor_mesh(x1,w1)
% TENSOR_MESH Create D-dimensional tensor-product from 1D meshes and weights.
%   [XD,WD] = TENSOR_MESH(X1,W1) creates a tensor product rule from D 1D rules
%   contained in the cell arrays X1 and W1.
%
% Example 1 (<a href="matlab:run_example tensor_mesh 1">run</a>)
%   [x1,w1] = gauss_hermite_rule(10);
%   [x2,w2] = gauss_hermite_rule(12);
%   [xd,wd] = tensor_mesh({x1,x2},{w1,w2});
%   subplot(2,2,1)
%   plot(xd(1,:),xd(2,:),'*k')
%   ns=[length(w1),length(w2)];
%   subplot(2,2,2)
%
%   stem3(xd(1,:),xd(2,:),wd,'fill')
%   subplot(2,2,3)
%   surf(reshape(xd(1,:),ns),reshape(xd(2,:),ns),reshape(wd,ns))
%   subplot(2,2,4)
%   surf(reshape(xd(1,:),ns),reshape(xd(2,:),ns),reshape(log(wd/max(wd))/log(10),ns))
%
% See also SMOLYAK_GRID, FULL_TENSOR_GRID

%   Andreas Keese, Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.

% get dimension
d = length(x1);
if( d ~= length(w1) )
    error( 'Length of points cell array doesn''t match that of the weights cell array.' );
end

% Number of points in each dimension
n1 = reshape( cellfun( 'length', x1 ), 1, [] );

% Total number of points
nd = prod( n1 );

% Resulting points and weights
xd = zeros(d,nd);
wd = ones(nd,1);

% For every dimension
for k=1:d
    % The idea is the following: we reshape the points array such that the
    % shape of the array has n1(k) points in dimension k and 1 in every
    % dimension else. Then we repeat the this array in every dimension i
    % except for i==k exactly n1(i) times given an array of size
    % n1(1)*...*n1(d). This gets flattened out by a further call to
    % reshape.
    sk=[ones(size(n1)), 1]; sk(k)=n1(k);
    rk=[n1, 1]; rk(k)=1;
    xd(k,:)=reshape( repmat( reshape( x1{k}, sk ), rk ), [1, nd] );
    wd=wd.*reshape( repmat( reshape( w1{k}, sk ), rk ), [nd, 1] );
end


