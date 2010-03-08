function tensor_stuff
clc
example_2_3
example_2_3_tt
example_3_3

function example_2_3_tt
fprintf('\n');
underline( 'Example_2_3' );
a=unitvector( 1, 3 );
b=unitvector( 2, 3 );
c=(a+b)/sqrt(2);
U1=ktensor( {a, a, a} );
U2=ktensor( {a, b, c} );
U3=ktensor( {a, c, b} );
A=U1+U2+U3;

d=sqrt(2/3)*a+sqrt(1/3)*b;
e=sqrt(2/3)*c+sqrt(1/3)*b;
V1=ktensor( {a, d, a} );
V2=ktensor( {a, e, b} );
Ab=sqrt(3/2)*( V1+V2 );

eval_print( 'norm(A-Ab)' );


function example_2_3
underline( 'Example_2_3' );
a=unitvector( 1, 3 );
b=unitvector( 2, 3 );
c=(a+b)/sqrt(2);
U1={a, a, a};
U2={a, b, c};
U3={a, c, b};
A=tensor_sum( U1, U2, U3);

d=sqrt(2/3)*a+sqrt(1/3)*b;
e=sqrt(2/3)*c+sqrt(1/3)*b;
V1={a, d, a};
V2={a, e, b};
Ab=tensor_scale( tensor_sum( V1, V2), sqrt(3/2));

eval_print( 'is_equal(A,Ab)' );



function example_3_3
underline( 'Example_3_3' );
a=unitvector( 1, 3 );
b=unitvector( 2, 3 );

U1={a, b, b};
U2={b, b, b};
U3={a, a, a};

sigma1=5;
sigma2=3;
sigma3=2;

%A=tensor_add( tensor_add( tensor_scale(U1, sigma1), tensor_scale(U2, sigma2)), tensor_scale(U3, sigma3)) 
A=tensor_sum( sigma1, U1, sigma2, U2, sigma3, U3);
eval_print( 'is_strongly_orthogonal(A)' );

sigma1b=sqrt(sigma1^2+sigma2^2);
sigma2b=sigma1*sigma3/sigma1b;
sigma3b=sigma2*sigma3/sigma1b;
ab=(sigma1*a+sigma2*b)/sigma1b;
bb=(sigma2*a-sigma1*b)/sigma1b;
U1b={ab, b, b};
U2b={ab, a, a};
U3b={bb, a, a};

Ab=tensor_sum( sigma1b, U1b, sigma2b, U2b, sigma3b, U3b);
eval_print( 'is_strongly_orthogonal(Ab)' );
eval_print( 'is_equal(A,Ab)' );

function bool=is_equal(T1,T2)
abstol=1e-8; reltol=1e-8;
abs=tensor_norm(tensor_add(T1,T2))/2;
bool=(tensor_error(T1,T2)<abstol+abs*reltol);


function bool=is_orthogonal(T)
abstol=1e-8; reltol=1e-8;
for i=1:3
    U=T{i}'*T{i};
    if i==1
        S=U;
    else
        S=S.*U;
    end
end
bool=(norm(S-diag(diag(S)))<abstol+reltol*norm(S));


function bool=is_complete_orthogonal(T)
abstol=1e-8; reltol=1e-8;
for i=1:3
    U=T{i}'*T{i};
    if i==1
        S=U;
    else
        S=S+U;
    end
end
bool=(norm(S-diag(diag(S)))<abstol+reltol*norm(S));

function bool=is_strongly_orthogonal(T)
bool=false;
if ~is_orthogonal(T)
    return;
end
abstol=1e-8; %reltol=1e-8;
for i=1:3
    U=T{i}'*T{i};
    D=diag(1./sqrt(diag(U)));
    U=D*U*D;
    S=(abs((U-0))<abstol | abs((U-1))<abstol);
    if ~all(S(:)); 
        return;
    end
end
bool=true;


function eval_print( cmd )
val=evalin('caller', cmd );
s=strtrim(evalc('disp(val)'));
fprintf( '%s: %s\n', cmd, s );

function A=tensor_sum( varargin )
i=1;
A=[];
while i<=length(varargin)
    x=varargin{i};
    i=i+1;
    if is_tensor(x)
        sigma=1;
        B=x;
    else
        sigma=x;
        B=varargin{i};
        i=i+1;
    end
    if isempty(A)
        A=tensor_scale(B,sigma);
    else
        A=tensor_add(A,B,sigma);
    end
end
        

