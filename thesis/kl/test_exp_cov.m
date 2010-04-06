function test_exp_cov

%compare_gs_eval
compare_gs_evec
%ghanem_spanos29
%ghanem_spanos30


function compare_gs_eval
clf
a=0.5;
b=1;

N=100;
[pos,els]=create_mesh_1d( -a, a, N );
G_N=mass_matrix( pos, els );
C=covariance_matrix( pos, {@exponential_covariance, {b,1}} );
[v,sig]=kl_solve_evp( C, G_N, 20 );
s=eval(a,b,20)
s-sig.^2
plot( s ); hold all
plot( sig.^2, 'r-.' );
legend( 'analytic ev', 'numerical ev' );


function compare_gs_evec
clf
a=0.5;
b=1;

N=100;
[pos,els]=create_mesh_1d( -a, a, N );
G_N=mass_matrix( pos, els );
C=covariance_matrix( pos, {@exponential_covariance, {b,1}} );
[v,sig]=kl_solve_evp( C, G_N, 20 );
s=eval(a,b,20)
s-sig.^2
x=linspace(-a,a);
for i=1:4
    y=evec(a,b,i,x);
    plot(x,y)
    hold all
    plot( pos, v(:,i)+0.03 );
end
legend( cellfun( @(x)(sprintf('n=%d',x) ), num2cell( 1:4 ), 'UniformOutput', false ) )


function ghanem_spanos29
clf
a=0.5;
b=1;
x=linspace(-a,a);
for i=1:4
    y=evec(a,b,i,x);
    plot(x,y)
    hold all
end
legend( cellfun( @(x)(sprintf('n=%d',x) ), num2cell( 1:4 ), 'UniformOutput', false ) )
    

function ghanem_spanos30
clf
a=0.5;
for b=[0.1,0.5,1.0,2.0,5.0,10.0]
    s=eval(a,b,10);
    plot(s)
    hold all
end
legend( cellfun( @(x)(sprintf('b=%g',x) ), num2cell( [0.1,0.5,1.0,2.0,5.0,10.0] ), 'UniformOutput', false ) )

function y=evec( a, b, i, x )
c=1/b;
if mod(i,2)==1
    w=get_even((i-1)/2,a,1/b);
    s=2*c./(w.^2+c^2);
    y=cos(w*x)/sqrt(a+sin(2*w*a)/(2*w));
else
    w=get_odd((i-2)/2,a,1/b);
    s=2*c./(w.^2+c^2);
    y=sin(w*x)/sqrt(a-sin(2*w*a)/(2*w));
end


function s=eval( a, b, n )
w=zeros(1,n);
w(1:2:end)=get_even(0:ceil(n/2)-1,a,1/b);
w(2:2:end)=get_odd(0:floor(n/2)-1,a,1/b);
c=1/b;
s=2*c./(w.^2+c^2);


function x=get_even(i,a,c)
x=i*pi/a;
x1=(i-0.5+100*eps)*pi/a;
x2=(i+0.5-100*eps)*pi/a;
x1(1)=0;
f=@(x)(c-x.*tan(x*a));
df=@(x)(-tan(x*a)-a*x./(cos(x*a).^2));
x=newton2(x,f,df,x1,x2,20);

if false
    %%
    n=10;
    i=1:n;
    xi=linspace(0,max(x),10000);
    plot( xi, c./xi, xi, tan(a*xi), x, tan(a*x), 'rx')
    ylim([-20,20])
    %%
end

function x=get_odd(i,a,c)
x=(i+0.5)*pi/a;
x1=(i-0.0+100*eps)*pi/a;
x2=(i+1.0-100*eps)*pi/a;
f=@(x)(c+x.*cot(x*a));
df=@(x)(cot(x*a)-a*x./(sin(x*a).^2));
x=newton2(x,f,df,x1,x2,20);

if false
    %%
    n=10;
    i=1:n;
    xi=linspace(0,max(x),10000);
    plot( xi, -c./xi, xi, cot(a*xi), x, cot(a*x), 'rx')
    ylim([-20,20])
    %%
end


function x=newton( x, f, df )
for k=1:20
    y=f(x);
    d=df(x);
    x=x-y./d;
end

function x=newton2( x, f, df, x1, x2, n )
for k=1:n
    y=f(x);
    d=df(x);
    xn=x-y./d;
    
    ind=(xn<x1) | (xn>x2);
    xn(ind)=0.5*(x1(ind)+x2(ind));
    
    ind=(sign(f(x1))==sign(f(xn)));
    x1(ind)=xn(ind);
    x2(~ind)=xn(~ind);
    x=xn;
end
