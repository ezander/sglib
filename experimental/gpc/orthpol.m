function p=orthpol( name, m, variant, params, varargin );

if nargin<3;
    variant='';
end
if nargin<4
    params=[];
end
options=varargin2options( varargin{:} );

s=orthpol_info( name, m, variant, params, options );
%p=generate_polynomials( s.a1n, s.a2n, s.a3n, s.a4n, m );
p=generate_polynomials2( s.a1n, s.a2n, s.a3n, s.a4n, m );

function p=generate_polynomials(a1n, a2n, a3n, a4n, m )
if any(a1n~=1 )
    a=a3n./a1n; b=a2n./a1n; c=a4n./a1n;
else
    a=a3n; b=a2n; c=a4n;
end
if isscalar(a); a=repmat(a,m+1,1); end
if isscalar(b); b=repmat(b,m+1,1); end
if isscalar(c); c=repmat(c,m+1,1); end

p=zeros(m+1,m+1);
p(1,m+1)=1;
p(2,:)=a(1)*[p(1,2:end) 0]+b(1)*p(1,:);
for n=3:m+1
    p(n,:)=a(n-1)*[p(n-1,2:end) 0]+b(n-1)*p(n-1,:)-c(n-1)*p(n-2,:);
end

function p=generate_polynomials2(a1n, a2n, a3n, a4n, m )
if any(a1n~=1 )
    a=a3n./a1n; b=a2n./a1n; c=a4n./a1n;
else
    a=a3n; b=a2n; c=a4n;
end
if isscalar(a); a=repmat(a,m+1,1); end
if isscalar(b); b=repmat(b,m+1,1); end
if isscalar(c); c=repmat(c,m+1,1); end
alpha=b./a;
beta=c./a;

p=zeros(m+1,m+1);
p(1,m+1)=1;
p(2,:)=a(1)*[p(1,2:end) 0]+b(1)*p(1,:);
for n=3:m+1
    p(n,:)=[p(n-1,2:end) 0]+alpha(n-1)*p(n-1,:)-beta(n-1)*p(n-2,:);
end



