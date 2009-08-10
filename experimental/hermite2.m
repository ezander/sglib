function hermite2

clc
format_poly( [1] );
format_poly( [0 0 0 0] );
format_poly( [2 3 4 5 6] );
format_poly( [1 0 3 0 5 0] );
format_poly( [0 1 0 3 0 5], 'symbol', 'z' );
format_poly( [2 3 -4] );
format_poly( [2 -3 4] );
format_poly( [-2 3 4] );
format_poly( [-2 -3 -4] );
options.tight=true||false;
options.twoline=false&&true;
options.symbol='u';
format_poly( [-1 -1 -1], options );
format_poly( [-1 -1], options );
format_poly( [-1], options );
format_poly( [1 1 1], options );
format_poly( [1 1], options );
format_poly( [1], options );
return


clc
chebyshev_first_ex=[0, 0, 0, 0, 0, 1; 0, 0, 0, 0, 1, 0; 0, 0, 0, 2, 0, -1; 0, 0, 4, 0, -3, 0; 0, 8, 0, -8, 0, 1; 16, 0, -20, 0, 5, 0];
chebyshev_first=make_chebyshev_first(5)
all(abs(chebyshev_first(:)-chebyshev_first_ex(:))<1e-12)

chebyshev_second_ex=[0, 0, 0, 0, 0, 1; 0, 0, 0, 0, 2, 0; 0, 0, 0, 4, 0, -1; 0, 0, 8, 0, -4, 0; 0, 16, 0, -12, 0, 1; 32, 0, -32, 0, 6, 0];
chebyshev_second=make_chebyshev_second(5)
all(abs(chebyshev_second(:)-chebyshev_second_ex(:))<1e-12)

hermite_stoch_ex=[0, 0, 0, 0, 0, 1; 0, 0, 0, 0, 1, 0; 0, 0, 0, 1, 0, -1; 0, 0, 1, 0, -3, 0; 0, 1, 0, -6, 0, 3; 1, 0, -10, 0, 15, 0];
hermite_stoch=make_hermite_stoch(5)
all(abs(hermite_stoch(:)-hermite_stoch_ex(:))<1e-12)

legendre_ex=[0, 0, 0, 0, 0, 1; 0, 0, 0, 0, 1, 0; 0, 0, 0, 3/2, 0, -1/2; 0, 0, 5/2, 0, -3/2, 0; 0, 35/8, 0, -15/4, 0, 3/8; 63/8, 0, -35/4, 0, 15/8, 0];
legendre=make_legendre(5)
all(abs(legendre(:)-legendre_ex(:))<1e-12)



function p=make_gegenbauer( m, alpha )
n=(0:m)-1;
%p=make_polynomials(1+(n~=0), 0, 1, m );

function p=make_jacobi( m, alpha, beta )
n=(0:m)-1;
%p=make_polynomials(1+(n~=0), 0, 1, m );


function p=make_chebyshev_first( m )
n=(0:m)-1;
p=make_polynomials(1+(n~=0), 0, 1, m );
%p=make_polynomials2(2.^(1+(n~=0)), 0, 1, m );

function p=make_chebyshev_second( m )
n=(0:m)-1;
p=make_polynomials(2, 0, 1, m );

function p=make_hermite_stoch( m )
n=(0:m)-1;
p=make_polynomials(1, 0, n, m );


function p=make_legendre( m )
n=max((0:m)-1,0);
p=make_polynomials((2*n+1)./(n+1), 0, n./(n+1), m );



function p=make_polynomials(a, b, c, m )

if isscalar(a); a=repmat(a,m+1,1); end
if isscalar(b); b=repmat(b,m+1,1); end
if isscalar(c); c=repmat(c,m+1,1); end

p=zeros(m+1,m+1);
p(1,m+1)=1;
p(2,:)=a(2)*[p(1,2:end) 0]+b(2)*p(1,:);
for n=3:m+1
    p(n,:)=a(n)*[p(n-1,2:end) 0]+b(n)*p(n-1,:)-c(n)*p(n-2,:);
end

function make_polynomials2( k, kp, h, m )
b=k(2:end)./k(1:end-1);
a=b.*( kp(2:end)./k(2:end) - kp(1:end-1)./k(1:end-1) );
c=k(2:end).*[1 k(1:end-2)].*h(1:end-1)./(k(1:end-1).^2.*[1 h(1:end-2)]);
p=make_polynomials( a, b, c, m );


function s=orthpol_info( name, variant, params, m, varargin )
options=varargin2options( varargin{:} );
[shift,options]=get_option( options, 'shift', [] );
[scale,options]=get_option( options, 'scale', [] );
[support,options]=get_option( options, 'support', [] );
[norm,options]=get_option( options, 'norm', [] );
check_unsupported_options( options, mfilename );

n=(0:m)'-1;
one=ones(m+1,1);

switch lower( name )
    case {'legendre', 'spherical' }
        s.supp=[-1,1];
        s.hn=2./(2*n+1);
        s.a1n=n+1;
        s.a2n=0*one;
        s.a3n=2*n+1;
        s.a4n=n;
    case {'chebyshev' }
        switch variant
            case {1, 'first', 'first king', '', [] }
                s.supp=[-1,1];
                s.hn=2./(2*n+1);
                s.a1n=n+1;
                s.a2n=0*one;
                s.a3n=2*n+1;
                s.a4n=n;
            case {2, 'second', 'second kind' }
        end
    case {'hermite' }
        switch variant
            case {'physicist', 'physics' }
            case {'stochasticist', 'stochastics', '', [] }
        end

    case {'jacobi' }
    case {'gegenbauer', 'ultraspherical' }
    case {'laguerre' }
    case {'generalized laguerre' }
                
end


