function [y,w] = grid_tensor_mesh(y1d,w1d)
% TENSOR_MESH Create N-dimensional tensor-product from 1D meshes and weights.
%   Y = TENSOR_MESH(Y1D,W1D) creates a tensor product rule from n 1D rules
%   contained in the cell arrays Y1D and W1D.
%
% Example (<a href="matlab:run_example grid_tensor_mesh">run</a>)
%   [y1,w1] = gauss_hermite_rule(10);
%   [y2,w2] = gauss_hermite_rule(12);
%   [y,w] = grid_tensor_mesh({y1,y2},{w1,w2})
%   subplot(2,2,1)
%   plot(y(1,:),y(2,:),'*k')
%   n=[length(w1),length(w2)];
%   subplot(2,2,2)
%   stem3(y(1,:),y(2,:),w,'fill')
%   subplot(2,2,3)
%   surf(reshape(y(1,:),n),reshape(y(2,:),n),reshape(w,n))
%
% See also GRID_SMOLYAK

%   Andreas Keese
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$

N = length(y1d);
if( N ~= length(w1d) )
    error( 'Length of points cell array doesn''t match that of the weights cell array.' );
end
    
n1d = zeros(N,1);
for n = 1 : N
    n1d(n)=length( y1d{n});
end

% total number of points:
ntot = prod( n1d );

% Resulting points:
y    = zeros(N,ntot);
w    = ones(1,ntot);

% For every dimension:
for n = 1:N
    % e.g.
    %  nprev: how often to repeat one number
    %  dist:  distance between same numbers,
    %
    % The result if y{n}={123,123,123}:
    %   n=1: 123123123123123123123123123  nprev=1 / dist=3
    %   n=2: 111222333111222333111222333  nprev=3 / dist=9
    %   n=3: 111111111222222222333333333  nprev=9 / dist=27
    %
    % As illustration of the following loops:
    %
    %     i: i=1   i=3
    %     j: 123123...
    %   n=1: 123123123123123123123123123  nprev=1 / dist=3
    %
    %     i: i=1      i=2
    %     j: j=1j=2j=3j=1j=2j=3
    %   n=2: 111222333111222333111222333  nprev=3 / dist=9
    %
    %     i: i=1
    %     j: 1=1      j=2      j=3
    %   n=3: 111111111222222222333333333  nprev=9 / dist=27
    %
    nprev = prod( n1d(1:n-1) );
    dist  = nprev * n1d(n);

    for i = 1 : ntot/ dist
        for j = 1:n1d(n)
            y(n,(1:nprev) + (i-1)*dist + (j-1)*nprev)=y1d{n}(j);
            w((1:nprev) + (i-1)*dist + (j-1)*nprev)=...
                w((1:nprev) + (i-1)*dist + (j-1)*nprev)*w1d{n}(j);
        end
    end
end
