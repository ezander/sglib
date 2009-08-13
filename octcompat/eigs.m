function [V,D]=eigs( varargin )

%    [V,D]=eigs( W, m, 'lm', eigs_options );
%    [V,D]=eigs( W, M, m, 'lm', eigs_options );

if isscalar(varargin{2})
  A=varargin{1};
  m=varargin{2};
  [V,D]=eig(A);
else
  A=varargin{1};
  B=varargin{2};
  m=varargin{3};
  %L=chol(B);
  [V,D]=eig(B\A);
end

d=diag(D);
[d,i]=sort(d,'descend');
i=i(1:m);
V=V(:,i);
D=D(i,i);




