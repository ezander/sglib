function [y,w] = quad1d_tensor_mesh(y1d,w1d)
% quad1d_tensor_mesh - creates N-Dimensional tensor-product from
%                         1D meshes and weights.
%
% y = quad1d_tensor_mesh(nodes,weights)
%    
% e.g.
%  [y1,w1] = quad1d_gauss_hermite(5);
%  [y2,w2] = quad1d_gauss_hermite(4);
%  [y,w] = quad1d_tensor_mesh({y1,y2},{w1,w2});

  N = length(y1d);
  assert( N == length(w1d) );
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
