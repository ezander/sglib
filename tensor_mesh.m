function [xd,wd] = tensor_mesh(x1,w1)
% TENSOR_MESH Create D-dimensional tensor-product from 1D meshes and weights.
%   [XD,WD] = TENSOR_MESH(X1,W1) creates a tensor product rule from D 1D rules
%   contained in the cell arrays X1 and W1.
%
% Example (<a href="matlab:run_example tensor_mesh">run</a>)
%   [x1,w1] = gauss_hermite_rule(10);
%   [x2,w2] = gauss_hermite_rule(12);
%   [xd,wd] = tensor_mesh({x1,x2},{w1,w2})
%   subplot(2,2,1)
%   plot(xd(1,:),xd(2,:),'*k')
%   ns=[length(w1),length(w2)];
%   subplot(2,2,2)
%   stem3(xd(1,:),xd(2,:),wd,'fill')
%   subplot(2,2,3)
%   surf(reshape(xd(1,:),ns),reshape(xd(2,:),ns),reshape(wd,ns))
%
% See also SMOLYAK_GRID, FULL_TENSOR_GRID

%   Andreas Keese, Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$

% get dimension
d = length(x1);
if( d ~= length(w1) )
    error( 'Length of points cell array doesn''t match that of the weights cell array.' );
end

% Number of points in each dimension
n1 = reshape( cellfun( 'length', x1 ), 1, [] );

% Total number of points
nd = prod( n1 );

% Resulting points
xd    = zeros(d,nd);
wd    = ones(1,nd);

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
    wd=wd.*reshape( repmat( reshape( w1{k}, sk ), rk ), [1, nd] );
end


% The following should go into the unit test
% x1{1}=[1,2,3];
% x1{2}=[4,5];
% x1{3}=[6,7,8,9];
% w1=x1;
% xde =[
%     1     2     3     1     2     3     1     2     3     1     2     3     1     2     3     1     2     3     1     2     3     1     2     3
%     4     4     4     5     5     5     4     4     4     5     5     5     4     4     4     5     5     5     4     4     4     5     5     5
%     6     6     6     6     6     6     7     7     7     7     7     7     8     8     8     8     8     8     9     9     9     9     9     9];
% wde = [
%     24    48    72    30    60    90    28    56    84    35    70   105    32    64    96    40    80   120    36    72   108    45    90   135 ];
% [xd,wd] = tensor_mesh(x1,w1);
% assert_equals( xd, xde, 'points' );
% assert_equals( wd, wde, 'weights' );
% % plust test for 1d
% % test for singleton dimensions
